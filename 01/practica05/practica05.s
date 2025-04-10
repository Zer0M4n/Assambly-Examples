//======================================================
// Nombre: circulo.s
// Autor: CESAR GONZALEZ SALAZAR
// Fecha: 10/abril/2025
// Descripción: Dibuja un círculo en terminal
// Equivalente en C:
// #include <stdio.h>
// #include <math.h>
//
// int main() {
//     int radius = 8;
//     int diameter = radius * 2;
//     
//     for (int y = -radius; y <= radius; y++) {
//         for (int x = -radius; x <= radius; x++) {
//             if (abs(sqrt(x*x + y*y) - radius) < 0.8) {
//                 printf("●");
//             } else {
//                 printf(" ");
//             }
//         }
//         printf("\n");
//     }
//     return 0;
// }
//======================================================

.section .data
dot:        .asciz "●"     // Carácter para el círculo
space:      .asciz " "     // Espacio
newline:    .asciz "\n"    // Nueva línea
radius:     .word 8        // Radio del círculo
threshold:  .double 0.8    // Umbral para suavizado

.section .text
.global _start

_start:
    // Inicializar valores
    ldr w19, radius       // w19 = radius
    neg w20, w19          // w20 = y = -radius

y_loop:
    cmp w20, w19          // y <= radius?
    b.gt end

    mov w21, w19          // w21 = x = -radius
    neg w21, w21

x_loop:
    cmp w21, w19          // x <= radius?
    b.gt next_y

    // Calcular x² + y²
    mul w22, w20, w20     // w22 = y²
    mul w23, w21, w21     // w23 = x²
    add w22, w22, w23     // w22 = x² + y²

    // Convertir a double para sqrt
    ucvtf d0, w22        // d0 = x² + y² (como double)
    fsqrt d0, d0         // d0 = sqrt(x² + y²)

    // Comparar con el radio (aproximación)
    scvtf d1, w19        // d1 = radius como double
    fsub d0, d0, d1      // d0 = distancia al borde
    fabs d0, d0          // valor absoluto

    ldr d1, threshold    // d1 = umbral
    fcmp d0, d1
    b.lt print_dot       // if (dist < threshold)

    // Imprimir espacio
    mov x0, #1
    ldr x1, =space
    mov x2, #1
    mov x8, #64
    svc #0
    b next_x

print_dot:
    // Imprimir punto del círculo
    mov x0, #1
    ldr x1, =dot
    mov x2, #3           // Tamaño del carácter Unicode
    mov x8, #64
    svc #0

next_x:
    add w21, w21, #1     // x++
    b x_loop

next_y:
    // Nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    add w20, w20, #1     // y++
    b y_loop

end:
    // Salir
    mov x0, #0
    mov x8, #93
    svc #0
