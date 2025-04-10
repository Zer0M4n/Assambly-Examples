// --------------------------------------------------------------
// Nombre del archivo : hola_mundo.s
// Autor              : [Cesar Gonzalez Salazar]
// Fecha              : 09/abril/2025
// Descripción        : Imprime "Hola mundo" en consola usando syscall.
// Plataforma         : Raspberry Pi OS 64-bit (Raspbian Linux)
// Arquitectura       : ARM64 (AArch64)
// Ensamblador        : GNU as (as), enlazador ld
// Ejecutar con       : as -o hola_mundo.o hola_mundo.s
//                      ld -o hola_mundo hola_mundo.o
//                      ./hola_mundo
// --------------------------------------------------------------

// Código C# equivalente:
// Console.WriteLine("Hola mundo");

.section .data
mensaje:        .asciz "Hola mundo\n"  // Cadena terminada en cero (null)

.section .text
.global _start

_start:
    // x0 = descriptor de archivo (1 = stdout)
    mov     x0, #1

    // x1 = dirección del mensaje
    ldr     x1, =mensaje

    // x2 = longitud del mensaje
    mov     x2, #11  // "Hola mundo\n" son 11 caracteres

    // x8 = número de syscall para write (64)
    mov     x8, #64

    // llamada al sistema write(int fd, const void *buf, size_t count)
    svc     #0

    // salir del programa, syscall exit (93)
    mov     x0, #0      // código de salida
    mov     x8, #93     // syscall exit
    svc     #0
