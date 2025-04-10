// --------------------------------------------------------------
// Nombre: calculadora_arm64.s
// Autor: César González Salazar
// Fecha: 09/abril/2025
// Descripción: Calculadora básica en ARM64 (AWS Graviton)
// --------------------------------------------------------------

.section .data
menu:       .asciz "\nCalculadora ARM64\n1. Suma\n2. Resta\n3. Multiplicación\n4. División\n5. Salir\nSeleccione: "
num1_p:     .asciz "\nIngrese primer número: "
num2_p:     .asciz "Ingrese segundo número: "
result_p:   .asciz "Resultado: "
err_p:      .asciz "Opción inválida!\n"
exit_p:     .asciz "\nSaliendo...\n"
newline:    .asciz "\n"
buffer:     .skip 16

.section .text
.global _start

_start:
    // Mostrar menú
menu_loop:
    mov x0, #1
    ldr x1, =menu
    mov x2, #80           // Longitud del menú
    mov x8, #64           // sys_write
    svc #0

    // Leer selección
    mov x0, #0            // stdin
    ldr x1, =buffer
    mov x2, #2            // Leer 1 dígito + newline
    mov x8, #63           // sys_read
    svc #0

    // Convertir opción a número
    ldrb w19, [x1]        // w19 = carácter opción
    sub w19, w19, #'0'    // Convertir ASCII a número

    // Validar opción
    cmp w19, #5
    b.eq exit_prog
    cmp w19, #1
    b.lt invalid
    cmp w19, #4
    b.gt invalid

    // Leer números
    mov x0, #1
    ldr x1, =num1_p
    mov x2, #22
    mov x8, #64
    svc #0

    mov x0, #0
    ldr x1, =buffer
    mov x2, #16
    mov x8, #63
    svc #0
    bl atoi               // x0 = primer número

    mov x20, x0           // Guardar num1 en x20

    mov x0, #1
    ldr x1, =num2_p
    mov x2, #22
    mov x8, #64
    svc #0

    mov x0, #0
    ldr x1, =buffer
    mov x2, #16
    mov x8, #63
    svc #0
    bl atoi               // x0 = segundo número

    mov x21, x0           // Guardar num2 en x21

    // Realizar operación
    cmp w19, #1
    b.eq suma
    cmp w19, #2
    b.eq resta
    cmp w19, #3
    b.eq multiplicacion
    cmp w19, #4
    b.eq division

suma:
    add x22, x20, x21
    b show_result

resta:
    sub x22, x20, x21
    b show_result

multiplicacion:
    mul x22, x20, x21
    b show_result

division:
    udiv x22, x20, x21    // División sin signo
    b show_result

show_result:
    // Mostrar resultado
    mov x0, #1
    ldr x1, =result_p
    mov x2, #11
    mov x8, #64
    svc #0

    ldr x0, =buffer
    mov x1, x22
    bl itoa                // Convertir resultado a string

    mov x2, x0             // Longitud del número
    mov x0, #1
    ldr x1, =buffer
    mov x8, #64
    svc #0

    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    b menu_loop

invalid:
    mov x0, #1
    ldr x1, =err_p
    mov x2, #16
    mov x8, #64
    svc #0
    b menu_loop

exit_prog:
    mov x0, #1
    ldr x1, =exit_p
    mov x2, #13
    mov x8, #64
    svc #0

    mov x0, #0
    mov x8, #93
    svc #0

// --------------------------------------------
// atoi - Convierte string a entero
// Entrada: x1 = string
// Salida: x0 = número
// --------------------------------------------
atoi:
    mov x0, #0            // Inicializar resultado
    mov x3, #10           // Base 10

atoi_loop:
    ldrb w2, [x1], #1     // Cargar siguiente carácter
    cmp w2, #10           // Check for newline
    b.eq atoi_done
    sub w2, w2, #'0'      // Convertir ASCII a dígito
    madd x0, x0, x3, x2   // resultado = resultado * 10 + dígito
    b atoi_loop

atoi_done:
    ret

// --------------------------------------------
// itoa - Convierte entero a string
// Entrada: x0 = buffer, x1 = número
// Salida: x0 = longitud
// --------------------------------------------
itoa:
    mov x2, #10           // Base 10
    mov x3, #0            // Contador de dígitos
    mov x4, x0            // Guardar inicio del buffer

    // Caso especial para 0
    cmp x1, #0
    b.ne itoa_loop
    mov w5, #'0'
    strb w5, [x0]
    mov x0, #1
    ret

itoa_loop:
    cmp x1, #0
    b.eq itoa_reverse
    udiv x5, x1, x2       // x5 = cociente
    msub x6, x5, x2, x1   // x6 = residuo (dígito)
    add x6, x6, #'0'      // Convertir a ASCII
    strb w6, [x0], #1     // Almacenar dígito
    add x3, x3, #1        // Incrementar contador
    mov x1, x5            // Actualizar número
    b itoa_loop

itoa_reverse:
    // Invertir los dígitos en el buffer
    mov x0, x4            // x0 = inicio buffer
    sub x2, x0, #1        // x2 = inicio - 1
    add x1, x0, x3        // x1 = final + 1
    lsr x5, x3, #1        // x5 = longitud/2

reverse_loop:
    cmp x5, #0
    b.eq itoa_done
    ldrb w6, [x0]         // Cargar desde inicio
    ldrb w7, [x1, #-1]!   // Cargar desde final
    strb w7, [x0], #1     // Intercambiar
    strb w6, [x1]
    sub x5, x5, #1
    b reverse_loop

itoa_done:
    mov x0, x3            // Retornar longitud
    ret
