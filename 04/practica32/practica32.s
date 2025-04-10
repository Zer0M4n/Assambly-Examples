// =====================================================
// Archivo: tabla5.s
// Descripción: Imprime la tabla de multiplicar del 5 (5x1 hasta 5x10)
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [08-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// int main() {
//     for (int i = 1; i <= 10; i++) {
//         printf("%d\n", 5 * i);
//     }
//     return 0;
// }
.section .bss
buffer: .skip 16     // para cada número convertido a string

.section .text
.global _start

_start:
    mov x20, #1        // contador i = 1

.loop:
    cmp x20, #11       // while i <= 10
    b.ge .fin

    // multiplicar: resultado = 5 * i
    mov x0, #5
    mul x0, x0, x20    // x0 = 5 * i

    // convertir resultado a texto
    ldr x1, =buffer
    bl itoa

    // agregar salto de línea al final
    ldr x2, =buffer
.fin_ascii:
    ldrb w3, [x2], #1
    cmp w3, #0
    b.ne .fin_ascii
    mov w3, #'\n'
    strb w3, [x2]

    // calcular longitud del buffer
    ldr x1, =buffer
    mov x2, x1
.len_loop:
    ldrb w3, [x2], #1
    cmp w3, #0
    b.ne .len_loop
    sub x2, x2, x1
    add x2, x2, #1

    // imprimir resultado
    mov x0, #1
    ldr x1, =buffer
    mov x8, #64
    svc #0

    // incrementar i
    add x20, x20, #1
    b .loop

.fin:
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// itoa: entero → texto
// Entrada: x0 = número, x1 = buffer
// ==========================
itoa:
    mov x2, #10
    add x3, x1, #15
    mov x4, x3
.itoa_loop:
    udiv x5, x0, x2
    msub x6, x5, x2, x0
    add x6, x6, #'0'
    sub x3, x3, #1
    strb w6, [x3]
    mov x0, x5
    cmp x0, #0
    b.ne .itoa_loop

    mov x5, x4
    sub x2, x5, x3
    mov x6, x2
.copy_ascii:
    ldrb w7, [x3], #1
    strb w7, [x1], #1
    subs x6, x6, #1
    b.ne .copy_ascii

    mov w7, #0
    strb w7, [x1]
    ret
