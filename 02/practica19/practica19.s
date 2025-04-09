// =====================================================
// Archivo: par_impar.s
// Descripción: Lee un número del usuario y dice si es par o impar
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [09-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// Code c


// int main() {
//     char buffer[10];
//     int num;
//     read(0, buffer, 10);
//     num = atoi(buffer);
//     if (num % 2 == 0)
//         printf("Par\n");
//     else
//         printf("Impar\n");
//     return 0;
// }
.section .bss
buffer: .skip 10

.section .rodata
msg_par:   .ascii "Par\n"
len_par = . - msg_par

msg_impar: .ascii "Impar\n"
len_impar = . - msg_impar

.section .text
.global _start

_start:
    // Leer número desde stdin
    mov x0, #0
    ldr x1, =buffer
    mov x2, #10
    mov x8, #63       // syscall: read
    svc #0

    // Convertir a entero
    ldr x1, =buffer
    bl atoi           // resultado en x0

    // Ver si es par o impar
    and x1, x0, #1    // x1 = x0 & 1
    cmp x1, #0
    beq es_par

es_impar:
    // Imprimir "Impar\n"
    mov x0, #1
    ldr x1, =msg_impar
    mov x2, #6
    mov x8, #64
    svc #0
    b salir

es_par:
    // Imprimir "Par\n"
    mov x0, #1
    ldr x1, =msg_par
    mov x2, #4
    mov x8, #64
    svc #0

salir:
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// atoi: ASCII → entero
// Entrada: x1 = buffer con caracteres
// Salida: x0 = número entero
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
