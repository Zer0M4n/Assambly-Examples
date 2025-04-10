// --------------------------------------------------------------
// Nombre del archivo : binario_a_decimal.s
// Autor              : [CESAR GONZALEZ SALAZAR]
// Fecha              : 09/abril/2025
// Descripción        : Convierte un string binario a entero decimal
//                      e imprime su representación decimal
// --------------------------------------------------------------

.section .data
cadena_binaria: .asciz "1101"
titulo:         .asciz "Decimal: "
salto_linea:    .asciz "\n"
buffer_decimal: .skip 12

.section .text
.global _start

_start:
    ldr     x0, =cadena_binaria     // x0 ← puntero a string binario
    bl      binario_a_entero        // x0 ← resultado decimal

    mov     x19, x0                 // Guardamos el resultado en x19 (registro preservado)
    
    // Convertir decimal a ASCII
    ldr     x2, =buffer_decimal     // x2 ← buffer destino
    bl      decimal_a_ascii         // salida: x0 = ptr, x1 = length
    
    mov     x20, x0                 // Guardamos el puntero al string
    mov     x21, x1                 // Guardamos la longitud

    // imprimir título "Decimal: "
    mov     x0, #1                  // file descriptor (stdout)
    ldr     x1, =titulo             // puntero al string
    mov     x2, #9                  // longitud del string
    mov     x8, #64                 // syscall write
    svc     #0

    // imprimir número convertido
    mov     x0, #1                  // file descriptor (stdout)
    mov     x1, x20                 // puntero al string del número
    mov     x2, x21                 // longitud del string
    mov     x8, #64                 // syscall write
    svc     #0

    // salto de línea
    mov     x0, #1                  // file descriptor (stdout)
    ldr     x1, =salto_linea        // puntero al string
    mov     x2, #1                  // longitud del string
    mov     x8, #64                 // syscall write
    svc     #0

    // salir
    mov     x0, #0                  // código de retorno
    mov     x8, #93                 // syscall exit
    svc     #0

// --------------------------------------------
// binario_a_entero
// Entrada : x0 = puntero a "1101"
// Salida  : x0 = 13
// --------------------------------------------
binario_a_entero:
    mov     x1, #0                  // inicializar resultado a 0
loop_bin:
    ldrb    w2, [x0], #1            // cargar byte y avanzar puntero
    cmp     w2, #0                  // comparar con null terminator
    beq     done_bin                // si es cero, terminar
    lsl     x1, x1, #1              // desplazar resultado a la izquierda
    cmp     w2, #'1'                // comparar con '1'
    cset    w3, eq                  // si es igual, w3 = 1, sino 0
    orr     x1, x1, x3              // agregar bit al resultado
    b       loop_bin
done_bin:
    mov     x0, x1                  // devolver resultado en x0
    ret

// --------------------------------------------
// decimal_a_ascii
// Entrada : x19 = número, x2 = buffer
// Salida  : x0 = puntero a string, x1 = longitud
// --------------------------------------------
decimal_a_ascii:
    mov     x3, x19                 // x3 = número a convertir
    add     x2, x2, #11             // apuntar al final del buffer
    mov     w4, #0                  // null terminator
    strb    w4, [x2]                // almacenar null terminator
    sub     x2, x2, #1              // retroceder una posición
    mov     x5, #10                 // divisor
    mov     x6, #0                  // contador de longitud

conv_loop:
    udiv    x1, x3, x5              // x1 = x3 / 10
    msub    x4, x1, x5, x3          // x4 = x3 - (x1 * 10) (resto)
    add     x4, x4, #'0'            // convertir a ASCII
    strb    w4, [x2]                // almacenar dígito
    sub     x2, x2, #1              // retroceder en el buffer
    add     x6, x6, #1              // incrementar contador
    mov     x3, x1                  // actualizar número
    cmp     x3, #0                  // ¿ya terminamos?
    b.ne    conv_loop               // si no, continuar
    
    add     x0, x2, #1              // puntero al inicio del string
    mov     x1, x6                  // longitud del string
    ret
