// =====================================================
// Archivo: cuadrado.s
// Descripción: Lee un número del usuario y muestra su cuadrado
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [09-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// Code c
// int main() {
//     char buffer[10];
//     int n;
//     read(0, buffer, 10);
//     n = atoi(buffer);
//     int cuadrado = n * n;
//     printf("%d\n", cuadrado);
//     return 0;
// }
.section .bss
buffer: .skip 10
resultado: .skip 16

.section .text
.global _start

_start:
    // Leer número desde teclado
    mov x0, #0
    ldr x1, =buffer
    mov x2, #10
    mov x8, #63           // syscall: read
    svc #0

    // Convertir a entero
    ldr x1, =buffer
    bl atoi               // número en x0

    // Guardar en x1 para multiplicar
    mov x1, x0
    mul x0, x0, x1        // x0 = x0 * x0

    // Convertir resultado a texto
    ldr x1, =resultado
    bl itoa

    // Agregar salto de línea
    ldr x2, =resultado
.busca_fin:
    ldrb w3, [x2], #1
    cmp w3, #0
    b.ne .busca_fin
    mov w3, #'\n'
    strb w3, [x2]

    // Calcular longitud total
    ldr x0, =resultado
    mov x1, x0
.calc_len:
    ldrb w2, [x1], #1
    cmp w2, #0
    b.ne .calc_len
    sub x2, x1, x0
    add x2, x2, #1

    // Imprimir resultado
    mov x0, #1
    ldr x1, =resultado
    mov x8, #64
    svc #0

    // Salida
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// atoi: convierte string ASCII → número entero
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
// itoa: convierte número → texto ASCII
// Entrada: x0 = número, x1 = buffer destino
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

