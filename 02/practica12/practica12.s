// =====================================================
// Archivo: suma_bucle.s
// Descripción: Suma los números del 1 al 10 usando bucle
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [08-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// C code
// int main() {
//     int suma = 0;
//     for (int i = 1; i <= 10; i++) {
//         suma += i;
//     }
//     printf("%d\n", suma);
//     return 0;
// }

.section .data
buffer: .skip 16       // espacio para almacenar el número convertido a texto

.section .text
.global _start

_start:
    mov x0, #1          // x0 = i = 1
    mov x1, #0          // x1 = suma

bucle:
    cmp x0, #10
    b.gt convertir      // si i > 10, salir del bucle

    add x1, x1, x0      // suma += i
    add x0, x0, #1      // i++

    b bucle

// ------------------------
// Convertir número (x1) a texto
// ------------------------
convertir:
    adr x3, buffer       // base del buffer
    add x4, x3, #15      // apunta al final
    mov x5, #10          // divisor base 10

conv_loop:
    mov x6, x1
    udiv x1, x1, x5
    msub x7, x1, x5, x6
    add x7, x7, #'0'
    sub x4, x4, #1
    strb w7, [x4]
    cmp x1, #0
    b.ne conv_loop

// ------------------------
// Imprimir resultado
// ------------------------
    mov x0, #1          // fd = stdout
    mov x1, x4          // dirección del número convertido
    adr x3, buffer
    add x2, x3, #15
    sub x2, x2, x4      // len = (buffer+15) - x4
    mov x8, #64         // syscall: write
    svc #0

// ------------------------
// Salida
// ------------------------
    mov x0, #0
    mov x8, #93         // syscall: exit
    svc #0

