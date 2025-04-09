// =====================================================
// Archivo: eco.s
// Descripción: Lee una entrada del usuario y la muestra (echo)
// Autor: [Tu nombre aquí]
// Fecha: [Fecha de creación]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// Code c
// int main() {
//     char buffer[100];
//     read(0, buffer, 100);
//     write(1, buffer, 100);
//     return 0;
// }
.section .bss
buffer: .skip 100       // reservar 100 bytes para entrada

.section .text
.global _start

_start:
    // syscall: read(0, buffer, 100)
    mov x0, #0           // stdin
    ldr x1, =buffer      // dirección del buffer
    mov x2, #100         // cantidad máxima a leer
    mov x8, #63          // syscall: read
    svc #0               // leer -> devuelve cantidad leída en x0

    // syscall: write(1, buffer, x0)
    mov x1, x1           // buffer sigue en x1
    mov x2, x0           // longitud real leída
    mov x0, #1           // stdout
    mov x8, #64          // syscall: write
    svc #0

    // exit(0)
    mov x0, #0
    mov x8, #93
    svc #0

