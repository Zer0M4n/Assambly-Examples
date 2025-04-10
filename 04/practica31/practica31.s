// =====================================================
// Archivo: comparar_100.s
// Descripción: Lee un número y dice si es menor, igual o mayor a 100
// Autor: [CESAR GONZALEZ SAALAZAR]
// Fecha: [08-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// int main() {
//     char buf[10];
//     int num;
//     read(0, buf, 10);
//     num = atoi(buf);
//     if (num > 100)
//         printf("Mayor que 100\n");
//     else if (num == 100)
//         printf("Igual a 100\n");
//     else
//         printf("Menor que 100\n");
//     return 0;
// }
.section .bss
buffer: .skip 10

.section .rodata
msg_mayor: .ascii "Mayor que 100\n"
len_mayor = . - msg_mayor

msg_igual: .ascii "Igual a 100\n"
len_igual = . - msg_igual

msg_menor: .ascii "Menor que 100\n"
len_menor = . - msg_menor

.section .text
.global _start

_start:
    // Leer número desde stdin
    mov x0, #0
    ldr x1, =buffer
    mov x2, #10
    mov x8, #63
    svc #0

    // Convertir buffer → entero
    ldr x1, =buffer
    bl atoi               // x0 = número ingresado

    // Comparar con 100
    mov x1, #100
    cmp x0, x1
    b.gt es_mayor
    b.eq es_igual

es_menor:
    // printf("Menor que 100\n")
    mov x0, #1
    ldr x1, =msg_menor
    mov x2, #16
    mov x8, #64
    svc #0
    b salir

es_igual:
    mov x0, #1
    ldr x1, =msg_igual
    mov x2, #14
    mov x8, #64
    svc #0
    b salir

es_mayor:
    mov x0, #1
    ldr x1, =msg_mayor
    mov x2, #16
    mov x8, #64
    svc #0

salir:
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// atoi: ASCII → número
// Entrada: x1 = buffer
// Salida: x0 = valor entero
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
