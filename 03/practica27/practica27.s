// --------------------------------------------------------------
// Nombre del archivo : decimal_a_octal.s  
// Autor              : César González Salazar
// Fecha              : 09/abril/2025
// Descripción        : Convierte un número decimal a su representación octal
//                      e imprime el resultado formateado
// --------------------------------------------------------------

.section .data
numero_decimal:  .word 1234         // Número decimal a convertir
titulo_dec:      .asciz "Decimal "
titulo_oct:      .asciz " = Octal: 0"  // El 0 inicial indica formato octal
salto_linea:     .asciz "\n"
buffer_octal:    .skip 12           // Buffer para dígitos octales

.section .text
.global _start

_start:
    // Cargar número decimal
    ldr     w19, numero_decimal     // w19 = número a convertir (1234)

    // Convertir decimal a string octal
    ldr     x0, =buffer_octal       // x0 = buffer destino
    mov     w1, w19                 // w1 = número decimal
    bl      decimal_a_octal         // x0 = puntero al string octal
    mov     x20, x0                 // Guardar puntero al string octal
    mov     x21, x1                 // Guardar longitud del string

    // Convertir decimal a ASCII para imprimir
    ldr     x2, =buffer_octal+11    // Usar parte final del buffer
    bl      decimal_a_ascii         // salida: x0 = ptr, x1 = length
    mov     x22, x0                 // Guardar puntero al string decimal
    mov     x23, x1                 // Guardar longitud

    // Imprimir título "Decimal "
    mov     x0, #1                  // file descriptor (stdout)
    ldr     x1, =titulo_dec         // puntero al string
    mov     x2, #8                  // longitud del string
    mov     x8, #64                 // syscall write
    svc     #0

    // Imprimir número decimal original
    mov     x0, #1
    mov     x1, x22                 // puntero al string decimal
    mov     x2, x23                 // longitud del string
    mov     x8, #64
    svc     #0

    // Imprimir título " = Octal: 0"
    mov     x0, #1
    ldr     x1, =titulo_oct
    mov     x2, #10                 // longitud del string (incluye el 0)
    mov     x8, #64
    svc     #0

    // Imprimir representación octal
    mov     x0, #1
    mov     x1, x20                 // puntero al string octal
    mov     x2, x21                 // longitud del string
    mov     x8, #64
    svc     #0

    // Salto de línea
    mov     x0, #1
    ldr     x1, =salto_linea
    mov     x2, #1
    mov     x8, #64
    svc     #0

    // Salir
    mov     x0, #0                  // código de retorno
    mov     x8, #93                 // syscall exit
    svc     #0

// --------------------------------------------
// decimal_a_octal
// Entrada : x0 = buffer destino, w1 = número decimal
// Salida  : x0 = puntero al string octal, x1 = longitud
// --------------------------------------------
decimal_a_octal:
    mov     x2, x0                  // x2 = buffer original (para calcular longitud)
    add     x0, x0, #11             // x0 = final del buffer
    mov     w3, #0                  // Contador de dígitos
    mov     w4, #0                  // Null terminator
    strb    w4, [x0]                // Almacenar null terminator
    mov     w5, #8                  // Base octal
    mov     w6, w1                  // w6 = número a convertir

octal_loop:
    udiv    w7, w6, w5              // w7 = cociente
    msub    w8, w7, w5, w6          // w8 = residuo (dígito octal)
    add     w8, w8, #'0'            // Convertir a ASCII
    sub     x0, x0, #1              // Retroceder en el buffer
    strb    w8, [x0]                // Almacenar dígito
    add     w3, w3, #1              // Incrementar contador
    mov     w6, w7                  // Actualizar número
    cbnz    w6, octal_loop          // Continuar si quedan dígitos

    // Calcular longitud
    sub     x1, x2, x0              // Diferencia entre inicio y fin
    add     x1, x1, #11             // Ajustar por posición inicial

    ret

// --------------------------------------------
// decimal_a_ascii
// Entrada : x19 = número, x2 = buffer
// Salida  : x0 = puntero a string, x1 = longitud
// --------------------------------------------
decimal_a_ascii:
    mov     x3, x19                 // x3 = número a convertir
    mov     w4, #0                  // Null terminator
    strb    w4, [x2]                // Almacenar null terminator
    sub     x2, x2, #1              // Retroceder una posición
    mov     x5, #10                 // Divisor
    mov     x6, #0                  // Contador de longitud

dec_loop:
    udiv    x1, x3, x5              // x1 = x3 / 10
    msub    x4, x1, x5, x3          // x4 = x3 - (x1 * 10) (resto)
    add     x4, x4, #'0'            // Convertir a ASCII
    strb    w4, [x2]                // Almacenar dígito
    sub     x2, x2, #1              // Retroceder en el buffer
    add     x6, x6, #1              // Incrementar contador
    mov     x3, x1                  // Actualizar número
    cmp     x3, #0                  // ¿Ya terminamos?
    b.ne    dec_loop                // Si no, continuar
    
    add     x0, x2, #1              // Puntero al inicio del string
    mov     x1, x6                  // Longitud del string
    ret
