//======================================================
// Nombre del archivo : not_operation_fixed.s
// Autor              : CESAR GONZALEZ SALAZAR
// Fecha              : 10/abril/2025
// Descripción        : Operación NOT corregida
// Ensamblador        : GNU as (ARM64) para Raspberry Pi OS
//======================================================

.global _start

.section .data
    numero:     .word 0b1010    // Número de entrada (10)
    result:     .word 0         // Para resultado
    msg:        .asciz "El resultado de NOT es: "
    bin_msg:    .asciz " (binario: "
    close_br:   .asciz ")"
    newline:    .asciz "\n"
    buffer:     .fill 33, 1, 0  // Buffer para binario

.section .text
_start:
    // Cargar direcciones correctamente
    adrp x19, numero
    add x19, x19, :lo12:numero
    adrp x20, result
    add x20, x20, :lo12:result

    // Cargar valor
    ldr w1, [x19]       // w1 = número

    // Operación NOT
    mvn w2, w1          // w2 = NOT w1
    str w2, [x20]       // Guardar resultado

    // Imprimir mensaje
    adrp x0, msg
    add x0, x0, :lo12:msg
    bl print_string

    // Imprimir número
    ldr w0, [x20]
    bl print_number

    // Imprimir binario
    adrp x0, bin_msg
    add x0, x0, :lo12:bin_msg
    bl print_string

    ldr w0, [x20]
    bl print_binary

    adrp x0, close_br
    add x0, x0, :lo12:close_br
    bl print_string

    // Nueva línea
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl print_string

    // Salir
    mov x0, #0
    mov x8, #93
    svc #0

// Subrutina para imprimir cadena
print_string:
    mov x2, #0
1:  ldrb w1, [x0, x2]
    cbz w1, 2f
    add x2, x2, #1
    b 1b
2:  mov x1, x0
    mov x0, #1
    mov x8, #64
    svc #0
    ret

// Subrutina para imprimir número (corregida)
print_number:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    adrp x1, buffer
    add x1, x1, :lo12:buffer
    add x1, x1, #31

    mov w2, #10
    mov w3, #0
1:  udiv w4, w0, w2
    msub w5, w4, w2, w0
    add w5, w5, #48
    strb w5, [x1], #-1
    add w3, w3, #1
    mov w0, w4
    cbnz w0, 1b

    // Corrección: usar registro consistente (w2 en lugar de x2)
    add x1, x1, #1
    mov x0, #1
    mov w2, w3          // Usamos w2 en lugar de x2 para longitud
    mov x8, #64
    svc #0

    ldp x29, x30, [sp], 16
    ret

// Subrutina para imprimir binario (corregida)
print_binary:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    adrp x1, buffer
    add x1, x1, :lo12:buffer
    mov x2, #31
    mov w3, #0

1:  lsr w4, w0, w2
    and w4, w4, #1
    add w4, w4, #48
    strb w4, [x1], #1
    add w3, w3, #1

    tst w3, #3
    b.ne 2f
    mov w4, #' '
    strb w4, [x1], #1
    add w3, w3, #1

2:  subs x2, x2, #1
    b.ge 1b

    adrp x0, buffer
    add x0, x0, :lo12:buffer
    mov x1, x0
    mov x0, #1
    mov x2, #35         // Longitud fija para simplificar
    mov x8, #64
    svc #0

    ldp x29, x30, [sp], 16
    ret
