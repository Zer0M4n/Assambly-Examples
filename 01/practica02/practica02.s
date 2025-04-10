//======================================================
// Nombre del archivo : showNumber.s
// Autor              : CESAR GONZALEZ SALAZAR
// Fecha              : 10/abril/2025
// Descripción        : Muestra un número por pantalla
// Ensamblador        : GNU as (ARM64) para Raspberry Pi OS
// Modo ejecución     : userland (no bare-metal)
//======================================================
// using System;
// class Program {
//     static void Main() {
//         Console.WriteLine(42);
//     }
// }
.section .data
    numero:     .asciz "42\n"       // Cadena a imprimir (terminada en NULL)

.section .text
.global _start

_start:
    // write(int fd, const void *buf, size_t count)
    // syscall número 64: write
    // x0 = file descriptor (1 = stdout)
    // x1 = dirección del buffer
    // x2 = longitud del buffer
    // x8 = número de syscall

    mov x0, #1                  // stdout (fd = 1)
    ldr x1, =numero             // dirección del string "42\n"
    mov x2, #3                  // longitud: 3 caracteres
    mov x8, #64                 // syscall número para write
    svc #0                      // invocar syscall

    // exit(int status)
    // syscall número 93
    mov x0, #0                  // status de salida = 0
    mov x8, #93                 // syscall número para exit
    svc #0                      // invocar syscall
