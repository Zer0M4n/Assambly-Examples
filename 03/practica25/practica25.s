// --------------------------------------------------------------
// Nombre del archivo : hex_a_decimal.s
// Autor              : César González Salazar
// Fecha              : 09/abril/2025
// Descripción        : Convierte un string hexadecimal a entero decimal
//                      e imprime su representación decimal
// --------------------------------------------------------------

// C# equivalente:
// string hex = "1A3F";
// int dec = Convert.ToInt32(hex, 16);
// Console.WriteLine("Hexadecimal " + hex + " = Decimal: " + dec);

.section .data
cadena_hex:      .asciz "1A3F"       // Cadena hexadecimal a convertir
titulo_hex:      .asciz "Hexadecimal "
titulo_dec:      .asciz " = Decimal: "
salto_linea:     .asciz "\n"
buffer_decimal:  .skip 12

.section .text
.global _start

_start:
    // Convertir hexadecimal a decimal
    ldr     x0, =cadena_hex         // x0 ← puntero a string hexadecimal
    bl      hexadecimal_a_entero    // x0 ← resultado decimal
    mov     x19, x0                 // Guardar el resultado decimal

    // Convertir decimal a ASCII para imprimir
    ldr     x2, =buffer_decimal     // x2 ← buffer destino
    bl      decimal_a_ascii         // salida: x0 = ptr, x1 = length
    mov     x20, x0                 // Guardar puntero al string decimal
    mov     x21, x1                 // Guardar longitud del string decimal

    // Imprimir título "Hexadecimal "
    mov     x0, #1                  // file descriptor (stdout)
    ldr     x1, =titulo_hex         // puntero al string
    mov     x2, #12                 // longitud del string
    mov     x8, #64                 // syscall write
    svc     #0

    // Imprimir valor hexadecimal original
    mov     x0, #1
    ldr     x1, =cadena_hex
    mov     x2, #4                  // longitud de "1A3F"
    mov     x8, #64
    svc     #0

    // Imprimir título " = Decimal: "
    mov     x0, #1
    ldr     x1, =titulo_dec
    mov     x2, #12                 // longitud del string
    mov     x8, #64
    svc     #0

    // Imprimir número decimal convertido
    mov     x0, #1
    mov     x1, x20                 // puntero al string decimal
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
// hexadecimal_a_entero
// Entrada : x0 = puntero a string hexadecimal (ej. "1A3F")
// Salida  : x0 = valor decimal (ej. 6719)
// --------------------------------------------
hexadecimal_a_entero:
    mov     x1, #0                  // Inicializar resultado a 0
hex_loop:
    ldrb    w2, [x0], #1            // Cargar byte y avanzar puntero
    cmp     w2, #0                  // Verificar fin de string
    beq     hex_done                // Si es cero, terminar
    
    // Convertir caracter a valor numérico
    cmp     w2, #'9'                // ¿Es dígito (0-9)?
    b.le    hex_digit
    cmp     w2, #'F'                // ¿Es mayúscula (A-F)?
    b.le    hex_upper
    cmp     w2, #'f'                // ¿Es minúscula (a-f)?
    b.le    hex_lower
    b       hex_loop                // Caracter inválido, ignorar

hex_digit:
    sub     w3, w2, #'0'            // Convertir '0'-'9' a 0-9
    b       hex_combine

hex_upper:
    sub     w3, w2, #'A'            // Convertir 'A'-'F' a 10-15
    add     w3, w3, #10
    b       hex_combine

hex_lower:
    sub     w3, w2, #'a'            // Convertir 'a'-'f' a 10-15
    add     w3, w3, #10

hex_combine:
    lsl     x1, x1, #4              // Desplazar resultado 4 bits (×16)
    orr     x1, x1, x3              // Combinar con nuevo dígito
    b       hex_loop

hex_done:
    mov     x0, x1                  // Devolver resultado en x0
    ret

// --------------------------------------------
// decimal_a_ascii
// Entrada : x19 = número, x2 = buffer
// Salida  : x0 = puntero a string, x1 = longitud
// --------------------------------------------
decimal_a_ascii:
    mov     x3, x19                 // x3 = número a convertir
    add     x2, x2, #11             // Apuntar al final del buffer
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
