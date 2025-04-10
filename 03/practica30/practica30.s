// --------------------------------------------------------------
// Nombre: cuadrado_ascii_arm64_fixed.s
// Autor: César González Salazar
// Fecha: 09/abril/2025
// Descripción: Cuadrado ASCII corregido para ARM64 (AWS)
// --------------------------------------------------------------

.section .data
size:       .word 5        // Tamaño del cuadrado (5x5)
border:     .byte '#'      // Carácter borde
fill:       .byte '*'      // Carácter relleno
newline:    .asciz "\n"    // Salto de línea
line:       .skip 32       // Buffer para línea

.section .text
.global _start

_start:
    // Cargar parámetros CORRECTAMENTE
    ldr x1, =size         // x1 = dirección de size
    ldr w1, [x1]          // w1 = valor de size (32 bits)
    ldr x2, =border       // x2 = dirección de border
    ldrb w2, [x2]         // w2 = carácter borde (8 bits)
    ldr x3, =fill         // x3 = dirección de fill
    ldrb w3, [x3]         // w3 = carácter relleno (8 bits)

    // Calcular size-1 (para comparaciones)
    sub w10, w1, #1       // w10 = size-1 (32 bits)

    // Bucle filas (i)
    mov w4, #0            // i = 0 (32 bits)
row_loop:
    cmp w4, w1
    b.ge exit             // Si i >= size, terminar

    // Bucle columnas (j)
    mov w5, #0            // j = 0 (32 bits)
col_loop:
    cmp w5, w1
    b.ge print_line       // Si j >= size, imprimir línea

    // Determinar si es borde
    cmp w4, #0            // Primera fila?
    b.eq is_border
    cmp w4, w10           // Última fila?
    b.eq is_border
    cmp w5, #0            // Primera columna?
    b.eq is_border
    cmp w5, w10           // Última columna?
    b.eq is_border

    // Es interior
    ldr x0, =line         // x0 = dirección de línea (64 bits)
    strb w3, [x0, w5, uxtw] // line[j] = fill (indexación segura)
    b next_col

is_border:
    ldr x0, =line
    strb w2, [x0, w5, uxtw] // line[j] = border

next_col:
    add w5, w5, #1        // j++
    b col_loop

print_line:
    // Terminar string con null
    ldr x0, =line
    mov w6, #0
    strb w6, [x0, x5]     // line[size] = '\0' (usando x5 extendido)

    // Imprimir línea (syscall necesita registros de 64 bits)
    mov x0, #1            // stdout (64 bits)
    ldr x1, =line         // buffer (64 bits)
    uxtw x2, w1           // Extender size a 64 bits
    mov x8, #64           // sys_write
    svc #0

    // Imprimir newline
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    svc #0

    add w4, w4, #1        // i++
    b row_loop

exit:
    // Exit (syscall necesita registros de 64 bits)
    mov x0, #0            // status (64 bits)
    mov x8, #93           // sys_exit
    svc #0
