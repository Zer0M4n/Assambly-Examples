// --------------------------------------------------------------
// Nombre del archivo : decimal_a_binario.s
// Autor              : César González Salazar
// Fecha              : 09/abril/2025
// Descripción        : Convierte un número decimal a su representación binaria
//                      e imprime el resultado formateado
// --------------------------------------------------------------

// C# equivalente:
// int dec = 25;
// string bin = Convert.ToString(dec, 2);
// Console.WriteLine("Decimal " + dec + " = Binario: " + bin);

.section .data
numero_decimal:  .word 25           // Número decimal a convertir
titulo_dec:      .asciz "Decimal "
titulo_bin:      .asciz " = Binario: "
salto_linea:     .asciz "\n"
buffer_binario:  .skip 33           // Buffer para 32 bits + null terminator

.section .text
.global _start

_start:
    // Cargar número decimal
    ldr     w19, numero_decimal     // w19 = número a convertir

    // Convertir decimal a string binario
    ldr     x0, =buffer_binario    // x0 = buffer destino
    mov     w1, w19                 // w1 = número decimal
    bl      decimal_a_binario       // x0 = puntero al string binario
    mov     x20, x0                 // Guardar puntero al string binario

    // Convertir decimal a ASCII para imprimir
    ldr     x2, =buffer_binario+32  // Usar parte final del buffer
    bl      decimal_a_ascii         // salida: x0 = ptr, x1 = length
    mov     x21, x0                 // Guardar puntero al string decimal
    mov     x22, x1                 // Guardar longitud

    // Imprimir título "Decimal "
    mov     x0, #1                  // file descriptor (stdout)
    ldr     x1, =titulo_dec         // puntero al string
    mov     x2, #8                  // longitud del string
    mov     x8, #64                 // syscall write
    svc     #0

    // Imprimir número decimal original
    mov     x0, #1
    mov     x1, x21                 // puntero al string decimal
    mov     x2, x22                 // longitud del string
    mov     x8, #64
    svc     #0

    // Imprimir título " = Binario: "
    mov     x0, #1
    ldr     x1, =titulo_bin
    mov     x2, #12                 // longitud del string
    mov     x8, #64
    svc     #0

    // Imprimir representación binaria
    mov     x0, #1
    mov     x1, x20                 // puntero al string binario
    mov     x2, #32                 // longitud máxima (32 bits)
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
// decimal_a_binario
// Entrada : x0 = buffer destino, w1 = número decimal
// Salida  : x0 = puntero al string binario (sin ceros a la izquierda)
// --------------------------------------------
decimal_a_binario:
    mov     x2, x0                  // x2 = puntero al buffer
    add     x0, x0, #32             // x0 = final del buffer
    mov     w3, #0                  // Contador de bits
    mov     w4, #'0'                // Carácter '0'
    mov     w5, #'1'                // Carácter '1'
    mov     w6, w1                  // w6 = número a convertir

bin_loop:
    tst     w6, #1                  // Testear bit menos significativo
    csel    w7, w5, w4, ne          // w7 = '1' si bit=1, '0' si no
    strb    w7, [x0, #-1]!          // Almacenar carácter y retroceder
    add     w3, w3, #1              // Incrementar contador
    lsr     w6, w6, #1              // Desplazar número a la derecha
    cbnz    w6, bin_loop            // Continuar si quedan bits

    // Eliminar ceros a la izquierda (opcional)
    // mov     x0, x0                  // x0 ya apunta al primer '1'

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
