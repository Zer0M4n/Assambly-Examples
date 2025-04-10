// --------------------------------------------------------------
// Nombre del archivo : suma_numeros.s
// Autor              : [Cesar Gonzalez Salazar]
// Fecha              : 09/abril/2025
// Descripción        : Suma 2 números y muestra el resultado en consola
// Plataforma         : Raspberry Pi OS 64-bit (Raspbian Linux)
// Arquitectura       : ARM64 (AArch64)
// Ensamblador        : GNU as (as), enlazador ld
// Ejecutar con       : as -o suma_numeros.o suma_numeros.s
//                      ld -o suma_numeros suma_numeros.o
//                      ./suma_numeros
// --------------------------------------------------------------

// Código C# equivalente:
// int a = 5;
// int b = 3;
// int resultado = a + b;
// Console.WriteLine("Resultado: 8");

.section .data
texto_resultado: .asciz "Resultado: "
salto_linea:     .asciz "\n"
resultado_str:   .skip 12       // buffer para guardar el número como string

.section .text
.global _start

_start:
    // Cargar los operandos
    mov     x1, #5          // número A
    mov     x2, #3          // número B
    add     x3, x1, x2      // x3 = resultado

    // Convertir entero en string (usaremos función nuestra)
    mov     x0, x3          // pasar resultado a x0
    ldr     x1, =resultado_str
    bl      int_a_ascii     // convierte x0 a string en x1

    // Imprimir "Resultado: "
    mov     x0, #1
    ldr     x1, =texto_resultado
    mov     x2, #10
    mov     x8, #64
    svc     #0

    // Imprimir el número convertido
    mov     x0, #1
    ldr     x1, =resultado_str
    mov     x2, #2          // longitud del número en texto ("8\n")
    mov     x8, #64
    svc     #0

    // Imprimir salto de línea
    mov     x0, #1
    ldr     x1, =salto_linea
    mov     x2, #1
    mov     x8, #64
    svc     #0

    // Salir del programa
    mov     x0, #0
    mov     x8, #93
    svc     #0

// -----------------------------------------------
// Subrutina: int_a_ascii
// Entrada:  x0 = número entero positivo
// Salida :  x1 = buffer con el string en ASCII
// Destruye: x2, x3
// -----------------------------------------------
int_a_ascii:
    mov     x2, #10         // divisor
    udiv    x3, x0, x2      // cociente
    msub    x2, x3, x2, x0  // x2 = x0 - (x3 * 10) = resto

    add     x2, x2, #'0'    // convertir a ASCII
    strb    w2, [x1]        // guardar carácter en buffer

    mov     x2, #0
    strb    w2, [x1, #1]    // terminador null
    ret
