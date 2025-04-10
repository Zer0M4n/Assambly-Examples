//======================================================
// Nombre: bytes_to_gb_fixed.s
// Autor: CESAR GONZALEZ SALAZAR
// Descripción: Conversión correcta de bytes a GB
// Ensamblador: GNU as (ARM64)
//======================================

.global _start

.section .data
    bytes:      .quad 5368709120  // 5 GB en bytes
    divisor:    .dword 1073741824 // 1024^3
    msg1:       .asciz " bytes = "
    msg2:       .asciz " GB "
    msg3:       .asciz "MB "
    msg4:       .asciz "KB "
    msg5:       .asciz "bytes\n"
    buffer:     .fill 32, 1, 0

.section .text
_start:
    // Cargar valores
    ldr x0, =bytes
    ldr x1, [x0]           // x1 = bytes totales
    ldr x2, =divisor
    ldr x3, [x2]           // x3 = divisor (1073741824)

    // Imprimir bytes originales
    mov x0, x1
    bl print_number

    // Imprimir " bytes = "
    ldr x0, =msg1
    bl print_string

    // Calcular GB
    udiv x4, x1, x3        // x4 = GB enteros
    msub x5, x4, x3, x1    // x5 = residuo (bytes restantes)

    // Imprimir GB si hay alguno
    cbz x4, skip_gb
    mov x0, x4
    bl print_number
    ldr x0, =msg2
    bl print_string
skip_gb:

    // Calcular MB restantes (x5 = bytes restantes)
    mov x6, #1048576        // 1024^2
    udiv x7, x5, x6         // x7 = MB
    msub x8, x7, x6, x5     // x8 = residuo

    // Imprimir MB si hay alguno
    cbz x7, skip_mb
    mov x0, x7
    bl print_number
    ldr x0, =msg3
    bl print_string
skip_mb:

    // Calcular KB restantes (x8 = bytes restantes)
    mov x6, #1024           // 1024
    udiv x9, x8, x6         // x9 = KB
    msub x10, x9, x6, x8    // x10 = residuo

    // Imprimir KB si hay alguno
    cbz x9, skip_kb
    mov x0, x9
    bl print_number
    ldr x0, =msg4
    bl print_string
skip_kb:

    // Imprimir bytes restantes si hay alguno
    cbz x10, skip_bytes
    mov x0, x10
    bl print_number
    ldr x0, =msg5
    bl print_string
skip_bytes:

    // Salir
    mov x0, #0
    mov x8, #93
    svc #0

// Subrutinas print_number y print_string igual que antes
print_number:
    ldr x1, =buffer
    add x1, x1, #31
    mov x2, #10
    mov x3, #0
1:
    udiv x4, x0, x2
    msub x5, x4, x2, x0
    add x5, x5, #48
    strb w5, [x1], #-1
    add x3, x3, #1
    mov x0, x4
    cbnz x0, 1b
    add x1, x1, #1
    mov x0, #1
    mov x2, x3
    mov x8, #64
    svc #0
    ret

print_string:
    mov x2, #0
1:
    ldrb w1, [x0, x2]
    cbz w1, 2f
    add x2, x2, #1
    b 1b
2:
    mov x1, x0
    mov x0, #1
    mov x8, #64
    svc #0
    ret
