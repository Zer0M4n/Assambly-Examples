// =====================================================
// Archivo: signo_numero.s
// Descripción: Lee un número y dice si es positivo, negativo o cero
// Autor: CESAR GONZALEZ SALAZAR
// Fecha: [09-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// int main() {
//     char buffer[10];
//     int n;
//     read(0, buffer, 10);
//     n = atoi(buffer);
//     if (n > 0)
//         printf("Positivo\n");
//     else if (n < 0)
//         printf("Negativo\n");
//     else
//         printf("Cero\n");
//     return 0;
// }
.section .bss
buffer: .skip 10

.section .rodata
msg_pos: .ascii "Positivo\n"
len_pos = . - msg_pos

msg_neg: .ascii "Negativo\n"
len_neg = . - msg_neg

msg_cero: .ascii "Cero\n"
len_cero = . - msg_cero

.section .text
.global _start

_start:
    // Leer número
    mov x0, #0
    ldr x1, =buffer
    mov x2, #10
    mov x8, #63
    svc #0

    // Convertir a entero
    ldr x1, =buffer
    bl atoi       // resultado en x0

    // Comparar
    cmp x0, #0
    b.gt positivo
    b.lt negativo

cero:
    // printf("Cero\n")
    mov x0, #1
    ldr x1, =msg_cero
    mov x2, #5
    mov x8, #64
    svc #0
    b salir

positivo:
    // printf("Positivo\n")
    mov x0, #1
    ldr x1, =msg_pos
    mov x2, #9
    mov x8, #64
    svc #0
    b salir

negativo:
    // printf("Negativo\n")
    mov x0, #1
    ldr x1, =msg_neg
    mov x2, #9
    mov x8, #64
    svc #0

salir:
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// atoi: convierte string ASCII a int
// Soporta solo números positivos (ajustable)
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
