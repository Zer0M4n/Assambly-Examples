// =====================================================
// Archivo: saludo.s
// Descripción: Imprime "Hola, mundo\n" en la consola
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [08-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// with c
// int main() {
//     write(1, "Hola, mundo\n", 12);
//     return 0;
// }
.section .data
mensaje: .ascii "Hola, mundo\n"
len = . - mensaje      // longitud de la cadena (12 bytes)

.section .text
.global _start

_start:
    mov x0, #1          // stdout
    ldr x1, =mensaje    // dirección del mensaje
    mov x2, #12         // longitud del mensaje
    mov x8, #64         // syscall: write
    svc #0

    // exit(0)
    mov x0, #0
    mov x8, #93
    svc #0

