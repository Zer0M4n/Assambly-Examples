//=================================================
// Nombre del archivo : triangulo.s
// Autor              : CESAR GONZALEZ SALAZAR
// Fecha              : 10/abril/2025
// Descripción        : Dibuja un triángulo de 5 líneas con asteriscos
// Ensamblador        : GNU as (ARM64) para Raspberry Pi OS
//======================================================
// using System;
// class Program {
//     static void Main() {
//         for (int i = 1; i <= 5; i++) {
//             Console.WriteLine(new string('*', i));
//         }
//     }
// }
.section .data
    asterisco:  .asciz "*"        // Un solo asterisco
    salto:      .asciz "\n"       // Nueva línea

.section .bss
    .lcomm buffer, 6              // Hasta 5 * + \n

.section .text
.global _start

_start:
    mov x20, #1              // x20 = línea actual (1 a 5)

loop_lineas:
    cmp x20, #6              // ¿ya imprimimos 5 líneas?
    bge fin_programa

    // --- Generar línea con X asteriscos ---
    ldr x21, =buffer         // puntero al inicio del buffer
    mov x22, #0              // contador de posición dentro del buffer

llenar_asteriscos:
    cmp x22, x20             // ¿llenamos suficientes *?
    beq insertar_salto

    ldr x10, =asterisco      // cargar dirección de "*"
    ldrb w0, [x10]           // cargar el byte '*'
    strb w0, [x21, x22]      // guardar en buffer[x22]
    add x22, x22, #1         // siguiente posición
    b llenar_asteriscos

insertar_salto:
    ldr x11, =salto          // cargar dirección de "\n"
    ldrb w0, [x11]           // cargar el byte '\n'
    strb w0, [x21, x22]      // poner al final del buffer
    add x22, x22, #1         // longitud total

    // --- Imprimir la línea generada ---
    mov x0, #1               // stdout
    ldr x1, =buffer          // dirección del buffer
    mov x2, x22              // longitud del string
    mov x8, #64              // syscall write
    svc #0

    // --- Siguiente línea ---
    add x20, x20, #1
    b loop_lineas

fin_programa:
    mov x0, #0
    mov x8, #93
    svc #0
