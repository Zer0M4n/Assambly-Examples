// =====================================================
// Nombre del archivo: suma_simple.s
// Descripción: Programa en ensamblador ARM64 que suma
//              dos enteros y devuelve el resultado.
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [08/04/2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// Code with c
// int main() {
//     int a = 10;
//     int b = 20;
//     int c = a + b;
//     return c;
// }
// int main() {
//     int a = 10;
//     int b = 20;
//     int c = a + b;
//     return c;
// }

.section .text
.global _start

_start:
    // Cargar 10 en el registro x0
    mov x0, #10            // x0 = 10

    // Cargar 20 en el registro x1
    mov x1, #20            // x1 = 20

    // Sumar los valores de x0 y x1, resultado en x2
    add x2, x0, x1         // x2 = x0 + x1 (x2 = 30)

    // Guardar valor de retorno en x0 (convención ABI)
    mov x0, x2             // return x2 (30)

    // Llamada al sistema exit (syscall número 93)
    mov x8, #93            // syscall: exit
    svc #0                 // llamada al sistema

