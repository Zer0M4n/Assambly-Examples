//======================================================
// Nombre del archivo : or_operation.s
// Autor              : CESAR GONZALEZ SALAZAR
// Fecha              : 10/abril/2025
// Descripción        : Realiza operación OR entre dos números
// Ensamblador        : GNU as (ARM64) para Raspberry Pi OS
//======================================================

.global _start

.section .data
    num1:       .word 0b1100    // Primer número (12 en binario)
    num2:       .word 0b1010    // Segundo número (10 en binario)
    result:     .word 0         // Para almacenar el resultado
    msg:        .asciz "El resultado de OR es: "
    newline:    .asciz "\n"
    buffer:     .fill 32, 1, 0  // Buffer para conversión de números

.section .text
_start:
    // Cargar direcciones de memoria
    adrp x19, num1
    add x19, x19, :lo12:num1
    adrp x20, num2
    add x20, x20, :lo12:num2
    adrp x21, result
    add x21, x21, :lo12:result

    // Cargar valores
    ldr w1, [x19]       // w1 = primer número
    ldr w2, [x20]       // w2 = segundo número

    // Realizar operación OR
    orr w3, w1, w2      // w3 = w1 OR w2

    // Guardar resultado
    str w3, [x21]       // Almacenar resultado

    // Imprimir mensaje
    adrp x0, msg
    add x0, x0, :lo12:msg
    bl print_string

    // Imprimir resultado en decimal
    ldr w0, [x21]       // Cargar resultado
    bl print_number

    // Imprimir nueva línea
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl print_string

    // Salir del programa
    mov x0, #0          // Código de salida 0
    mov x8, #93         // syscall exit
    svc 0

// Subrutina para imprimir cadena
// x0: dirección de la cadena
print_string:
    mov x2, #0          // Contador de longitud
1:
    ldrb w1, [x0, x2]   // Cargar byte
    cbz w1, 2f          // Si es null, terminar
    add x2, x2, #1      // Incrementar contador
    b 1b
2:
    mov x1, x0          // Dirección del mensaje
    mov x0, #1          // stdout
    mov x8, #64         // syscall write
    svc 0
    ret

// Subrutina para imprimir número (0-255)
// w0: número a imprimir
print_number:
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    add x1, x1, #31     // Posicionarse al final del buffer

    // Convertir número a ASCII
    mov w2, #10         // Divisor
1:
    udiv w3, w0, w2     // w3 = cociente
    msub w4, w3, w2, w0 // w4 = residuo
    add w4, w4, #48     // Convertir a ASCII
    strb w4, [x1], #-1  // Almacenar dígito
    mov w0, w3          // Actualizar número
    cbnz w0, 1b         // Repetir si no es cero

    // Calcular longitud
    adrp x2, buffer
    add x2, x2, :lo12:buffer
    add x2, x2, #31     // Final del buffer
    sub x2, x2, x1      // Longitud = final - posición actual

    // Imprimir número
    add x1, x1, #1      // Ajustar posición
    mov x0, #1          // stdout
    mov x8, #64         // syscall write
    svc 0
    ret
