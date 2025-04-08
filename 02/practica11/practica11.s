// =====================================================
// Archivo: maximo.s
// Descripción: Compara dos números y retorna el mayor
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [08-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// Code with in c 
// int main() {
//     int a = 15;
//     int b = 42;
//     int max;
//     if (a > b)
//         max = a;
//     else
//         max = b;
//     return max;
// }
.section .data
buffer: .skip 16     // 16 bytes de espacio para el número

.section .text
.global _start

_start:
    // Cargar los valores a comparar
    mov x0, #15
    mov x1, #42

    cmp x0, x1
    b.gt mayor
    mov x2, x1        // x2 = max
    b convertir

mayor:
    mov x2, x0        // x2 = max

// ------------------------
// Convertir número en x2 a string ASCII en buffer
// ------------------------
convertir:
    adr x3, buffer       // x3 = dirección base de buffer
    add x4, x3, #15      // x4 apunta al final del buffer
    mov x5, #10          // divisor base 10

conv_loop:
    mov x6, x2
    udiv x2, x2, x5
    msub x7, x2, x5, x6  // x7 = x6 - (x2 * 10)
    add x7, x7, #'0'     // ASCII
    sub x4, x4, #1       // mover hacia atrás
    strb w7, [x4]        // guardar byte ASCII
    cmp x2, #0
    b.ne conv_loop

// ------------------------
// Imprimir con write(fd=1, buf=x4, len=(buffer+15)-x4)
// ------------------------
    mov x0, #1            // fd = stdout
    mov x1, x4            // dirección de inicio
    adr x3, buffer
    add x2, x3, #15
    sub x2, x2, x4        // len = (buffer+15) - x4
    mov x8, #64           // syscall: write
    svc #0

// ------------------------
// Salida normal
// ------------------------
    mov x0, #0
    mov x8, #93           // syscall: exit
    svc #0

