//===============================================================
// Nombre: suma.s
// Descripción: Suma dos enteros y muestra el resultado en stdout
// Arquitectura: ARM64 (AArch64) - Raspberry Pi OS 64-bit
// Autor: Cesar Gonzalez
// Fecha: 2025-04-09
//===============================================================
.section .data
output:    .asciz "Resultado: %d\n"   // Formato para printf

.section .text
.global main
.extern printf

main:
    // Cargar constantes a = 5, b = 7
    mov x0, 5              // x0 contiene el primer número (a = 5)
    mov x1, 7              // x1 contiene el segundo número (b = 7)

    // Realizar la suma: x2 = x0 + x1
    add x2, x0, x1         // x2 = x0 + x1

    // Preparar argumentos para printf
    ldr x0, =output        // x0: puntero al string "Resultado: %d\n"
    mov x1, x2             // x1: resultado de la suma

    // Llamar a printf
    bl printf              // invoca a printf("Resultado: %d\n", x2)

    // Salida del programa
    mov x0, 0              // Código de salida = 0
    ret                    // Regresar al sistema
