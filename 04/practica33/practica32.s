// =====================================================
// Archivo: suma_n.s
// Descripción: Suma los números naturales desde 1 hasta N
//              (el usuario ingresa N por teclado)
// Autor: [CESAR GONZALEZ SALAZAR]
// Fecha: [09-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// =====================================================
// int main() {
//     char buffer[10];
//     int n, suma = 0;
//     read(0, buffer, 10);
//     n = atoi(buffer);
//     for (int i = 1; i <= n; i++) {
//         suma += i;
//     }
//     printf("%d\n", suma);
//     return 0;
// }
.section .bss
buffer: .skip 10
resultado: .skip 16

.section .text
.global _start

_start:
    // Leer N desde stdin
    mov x0, #0
    ldr x1, =buffer
    mov x2, #10
    mov x8, #63
    svc #0

    // Convertir N
    ldr x1, =buffer
    bl atoi         // x0 = N
    mov x20, x0     // N en x20

    // Inicializar suma = 0, i = 1
    mov x21, #0     // x21 = suma
    mov x22, #1     // x22 = i

.bucle:
    cmp x22, x20
    b.gt .fin_bucle

    add x21, x21, x22
    add x22, x22, #1
    b .bucle

.fin_bucle:
    // Convertir resultado (x21) a string
    mov x0, x21
    ldr x1, =resultado
    bl itoa

    // Agregar '\n' al final
    ldr x2, =resultado
.find_end:
    ldrb w3, [x2], #1
    cmp w3, #0
    b.ne .find_end
    mov w3, #'\n'
    strb w3, [x2]

    // Calcular longitud
    ldr x0, =resultado
    mov x1, x0
.len_loop:
    ldrb w2, [x1], #1
    cmp w2, #0
    b.ne .len_loop
    sub x2, x1, x0
    add x2, x2, #1

    // Imprimir
    mov x0, #1
    ldr x1, =resultado
    mov x8, #64
    svc #0

    // exit(0)
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// atoi: ASCII → int
// Entrada: x1 = buffer
// Salida: x0 = número
// ==========================
atoi:
    mov x0, #0
    mov x7, #10
.atoi_loop:
    ldrb w2, [x1], #1
    cmp w2, #'0'
    blt .atoi_done
    cmp w2, #'9'
    bgt .atoi_done
    sub w2, w2, #'0'
    mul x0, x0, x7
    add x0, x0, x2
    b .atoi_loop
.atoi_done:
    ret

// ==========================
// itoa: int → ASCII
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

