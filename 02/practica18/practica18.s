// =====================================================
// Archivo: contador.s
// Descripción: Muestra números del 1 al 9 en consola
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [09-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// Code C
// int main() {
//     for (int i = 1; i <= 9; i++) {
//         printf("%d\n", i);
//     }
//     return 0;
// }
.section .bss
buffer: .skip 16        // espacio para texto por número

.section .text
.global _start

_start:
    mov x20, #1          // contador i = 1

.bucle:
    cmp x20, #10         // while (i <= 9)
    b.ge .fin

    // convertir x20 a texto
    mov x0, x20
    ldr x1, =buffer
    bl itoa

    // agregar salto de línea '\n'
    ldr x2, =buffer
.agrega_nl:
    ldrb w3, [x2], #1
    cmp w3, #0
    b.ne .agrega_nl
    mov w3, #'\n'
    strb w3, [x2]

    // imprimir
    mov x0, #1            // stdout
    ldr x1, =buffer
    mov x2, x2
    sub x2, x2, x1
    add x2, x2, #1        // longitud = (fin - inicio) + '\n'
    mov x8, #64
    svc #0

    // incrementar i
    add x20, x20, #1
    b .bucle

.fin:
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// itoa: convierte entero a string ASCII
// Entrada: x0 = número, x1 = buffer destino
// Salida: resultado en x1
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
.copy_digits:
    ldrb w7, [x3], #1
    strb w7, [x1], #1
    subs x6, x6, #1
    b.ne .copy_digits

    mov w7, #0
    strb w7, [x1]
    ret
