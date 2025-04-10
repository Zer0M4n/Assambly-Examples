// --------------------------------------------------------------
// Nombre: tabla_multiplicar_2.s
// Arquitectura: ARM64 (aarch64)
// Descripción: Muestra la tabla de multiplicar del 2
// --------------------------------------------------------------

.section .data
header:     .asciz "\nTabla de multiplicar del 2\n"
            .asciz "-----------------------\n"
line_format: .asciz "2 x %d = %d\n"
newline:    .asciz "\n"

.section .text
.global _start

_start:
    // Mostrar encabezado
    mov x0, #1                  // stdout
    adrp x1, header
    add x1, x1, :lo12:header
    mov x2, #49                 // Longitud del encabezado completo
    mov x8, #64                 // sys_write
    svc #0

    // Configurar contador (1-10)
    mov x19, #1                 // x19 = contador (i)
    mov x20, #2                 // x20 = número a multiplicar (2)

multiplication_loop:
    // Calcular 2 x i
    mul x21, x19, x20           // x21 = 2 * i

    // Preparar para syscall printf (usaremos syscall write)
    // Necesitamos formatear la cadena primero
    // Para simplificar, haremos dos syscalls write

    // Mostrar "2 x "
    mov x0, #1
    adrp x1, line_format
    add x1, x1, :lo12:line_format
    mov x2, #4                  // "2 x "
    mov x8, #64
    svc #0

    // Mostrar el número (convertir a ASCII)
    add x0, x19, #'0'           // Convertir número a ASCII
    adrp x1, input_buffer
    add x1, x1, :lo12:input_buffer
    strb w0, [x1]               // Almacenar dígito

    mov x0, #1
    mov x2, #1                  // Longitud 1
    mov x8, #64
    svc #0

    // Mostrar " = "
    mov x0, #1
    adrp x1, equals_sign
    add x1, x1, :lo12:equals_sign
    mov x2, #3                  // " = "
    mov x8, #64
    svc #0

    // Mostrar resultado (convertir a ASCII)
    // Para números de un dígito (1-9)
    cmp x21, #10
    b.ge two_digits

    // Un dígito
    add x0, x21, #'0'
    adrp x1, input_buffer
    add x1, x1, :lo12:input_buffer
    strb w0, [x1]

    mov x0, #1
    mov x2, #1
    mov x8, #64
    svc #0

    b next_iteration

two_digits:
    // Dos dígitos (solo 10 en este caso)
    mov x0, #'1'               // Decenas
    adrp x1, input_buffer
    add x1, x1, :lo12:input_buffer
    strb w0, [x1]

    mov x0, #1
    mov x2, #1
    mov x8, #64
    svc #0

    mov x0, #'0'               // Unidades
    strb w0, [x1]

    mov x0, #1
    mov x2, #1
    mov x8, #64
    svc #0

next_iteration:
    // Nueva línea
    mov x0, #1
    adrp x1, newline
    add x1, x1, :lo12:newline
    mov x2, #1
    mov x8, #64
    svc #0

    // Incrementar contador
    add x19, x19, #1
    cmp x19, #10
    b.le multiplication_loop

    // Salir
    mov x0, #0                 // status
    mov x8, #93                // sys_exit
    svc #0

.section .data
equals_sign: .asciz " = "
input_buffer: .space 2
