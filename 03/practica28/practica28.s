// --------------------------------------------------------------
// Nombre del archivo : decimal_a_bcd.s
// Autor              : César González Salazar
// Fecha              : 09/abril/2025
// Descripción        : Convierte un número decimal a BCD
//                      e imprime su representación en formato BCD
// --------------------------------------------------------------

.section .data
numero_decimal:  .word 9876         // Número decimal a convertir (máx 9999)
titulo_dec:      .asciz "Decimal: "
titulo_bcd:      .asciz " | BCD: 0x"
salto_linea:     .asciz "\n"
buffer_bcd:      .skip 5            // Buffer para 4 dígitos BCD + null
hex_chars:       .asciz "0123456789ABCDEF"

.section .text
.global _start

_start:
    // Cargar número decimal
    ldr     w19, numero_decimal     // w19 = número a convertir (9876)
    
    // Convertir decimal a BCD
    mov     w0, w19                 // w0 = número decimal
    bl      decimal_a_bcd           // w0 = valor BCD
    mov     w20, w0                 // Guardar valor BCD
    
    // Convertir BCD a string hexadecimal
    ldr     x0, =buffer_bcd         // x0 = buffer destino
    mov     w1, w20                 // w1 = valor BCD
    bl      bcd_a_string            // x0 = puntero al string BCD
    mov     x21, x0                 // Guardar puntero al string BCD
    
    // Convertir decimal a ASCII para imprimir
    ldr     x0, =buffer_bcd+4       // Usar parte final del buffer
    mov     w1, w19                 // w1 = número decimal
    bl      decimal_a_ascii         // salida: x0 = ptr, x1 = length
    mov     x22, x0                 // Guardar puntero al string decimal
    mov     x23, x1                 // Guardar longitud

    // Imprimir título "Decimal: "
    mov     x0, #1                  // file descriptor (stdout)
    ldr     x1, =titulo_dec         // puntero al string
    mov     x2, #9                  // longitud del string
    mov     x8, #64                 // syscall write
    svc     #0

    // Imprimir número decimal original
    mov     x0, #1
    mov     x1, x22                 // puntero al string decimal
    mov     x2, x23                 // longitud del string
    mov     x8, #64
    svc     #0

    // Imprimir título " | BCD: 0x"
    mov     x0, #1
    ldr     x1, =titulo_bcd
    mov     x2, #10                 // longitud del string
    mov     x8, #64
    svc     #0

    // Imprimir representación BCD
    mov     x0, #1
    mov     x1, x21                 // puntero al string BCD
    mov     x2, #4                  // longitud fija para 4 dígitos
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
// decimal_a_bcd
// Entrada : w0 = número decimal (0-9999)
// Salida  : w0 = valor BCD (cada nibble = 1 dígito decimal)
// --------------------------------------------
decimal_a_bcd:
    mov     w1, #0                  // Inicializar resultado
    mov     w2, #1000               // Divisor inicial
    
bcd_loop:
    udiv    w3, w0, w2              // w3 = dígito actual
    lsl     w1, w1, #4              // Hacer espacio para nuevo dígito
    orr     w1, w1, w3              // Combinar dígito
    msub    w0, w3, w2, w0          // w0 = resto
    
    // Actualizar divisor
    mov     w4, #10
    udiv    w2, w2, w4              // Dividir divisor por 10
    cbnz    w2, bcd_loop            // Continuar hasta que divisor sea 0
    
    mov     w0, w1                  // Devolver resultado en w0
    ret

// --------------------------------------------
// bcd_a_string
// Entrada : x0 = buffer, w1 = valor BCD
// Salida  : x0 = puntero al string BCD
// --------------------------------------------
bcd_a_string:
    ldr     x2, =hex_chars          // Tabla de caracteres hexadecimales
    mov     w3, #4                  // Contador de dígitos (4 para 16 bits)
    add     x0, x0, #3              // Empezar desde el final del buffer
    
bcd_to_str_loop:
    and     w4, w1, #0xF            // Extraer nibble inferior
    ldrb    w5, [x2, x4]            // Obtener caracter hexadecimal
    strb    w5, [x0], #-1           // Almacenar y retroceder
    lsr     w1, w1, #4              // Desplazar siguiente nibble
    subs    w3, w3, #1              // Decrementar contador
    b.ne    bcd_to_str_loop         // Continuar si quedan dígitos
    
    add     x0, x0, #1              // Ajustar puntero al inicio del string
    ret

// --------------------------------------------
// decimal_a_ascii
// Entrada : x0 = buffer, w1 = número
// Salida  : x0 = puntero a string, x1 = longitud
// --------------------------------------------
decimal_a_ascii:
    mov     x2, x0                  // Guardar buffer original
    mov     w3, #0                  // Null terminator
    strb    w3, [x0]                // Almacenar null terminator
    sub     x0, x0, #1              // Retroceder una posición
    mov     x4, #10                 // Divisor
    mov     x5, #0                  // Contador de longitud
    mov     w6, w1                  // w6 = número a convertir

dec_loop:
    udiv    x7, x6, x4              // x7 = x6 / 10
    msub    x8, x7, x4, x6          // x8 = x6 - (x7 * 10) (resto)
    add     x8, x8, #'0'            // Convertir a ASCII
    strb    w8, [x0]                // Almacenar dígito
    sub     x0, x0, #1              // Retroceder en el buffer
    add     x5, x5, #1              // Incrementar contador
    mov     x6, x7                  // Actualizar número
    cmp     x6, #0                  // ¿Ya terminamos?
    b.ne    dec_loop                // Si no, continuar
    
    add     x0, x0, #1              // Puntero al inicio del string
    mov     x1, x5                  // Longitud del string
    ret
