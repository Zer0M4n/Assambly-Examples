//======================================================
// Nombre: trifuerza.s
// Autor: Tu Nombre
// Fecha: 10/abril/2025
// Descripción: Dibuja una Trifuerza en terminal
// Equivalente en C:
// #include <stdio.h>
// int main() {
//     int rows = 4;
//     for (int i = 1; i <= rows; i++) {
//         printf("%*s", rows-i, "");
//         for (int j = 0; j < i*2-1; j++) 
//             printf("▲");
//         printf("\n");
//     }
//     for (int i = 1; i <= rows; i++) {
//         printf("%*s", rows-i, "");
//         for (int j = 0; j < i*2-1; j++) 
//             printf("▲");
//         printf("%*s", (rows-i)*2+1, "");
//         for (int j = 0; j < i*2-1; j++) 
//             printf("▲");
//         printf("\n");
//     }
//     return 0;
// }
//======================================================

.section .data
tri_char:   .asciz "▲"    // Carácter del triángulo
space:      .asciz " "    // Espacio
newline:    .asciz "\n"   // Nueva línea
rows:       .word 4       // Filas por triángulo

.section .text
.global _start

_start:
    // Configurar terminal
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64          // sys_write
    svc #0

    // Dibujar parte superior (1 triángulo)
    // Equivalente a: for(i=1; i<=rows; i++)
    mov w19, #1          // i = 1 (contador filas)
top_loop:
    cmp w19, #4          // rows = 4
    b.gt middle

    // Imprimir espacios
    // Equivalente a: printf("%*s", rows-i, "")
    mov x0, #1
    ldr x1, =space
    mov w20, #4          // rows
    sub w20, w20, w19    // rows - i
spaces_loop:
    cmp w20, #0
    b.le print_tri
    mov x2, #1
    mov x8, #64
    svc #0
    sub w20, w20, #1
    b spaces_loop

    // Imprimir triángulo
    // Equivalente a: for(j=0; j<i*2-1; j++) printf("▲")
print_tri:
    mov w21, #0          // j = 0
    lsl w22, w19, #1     // i*2
    sub w22, w22, #1     // i*2-1
tri_chars_loop:
    cmp w21, w22
    b.ge next_top_row
    mov x0, #1
    ldr x1, =tri_char
    mov x2, #3           // Tamaño del carácter Unicode
    mov x8, #64
    svc #0
    add w21, w21, #1
    b tri_chars_loop

next_top_row:
    // Nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    add w19, w19, #1
    b top_loop

middle:
    // Dibujar parte inferior (2 triángulos)
    // Equivalente a: for(i=1; i<=rows; i++)
    mov w19, #1          // i = 1
bottom_loop:
    cmp w19, #4          // rows = 4
    b.gt end

    // Primer triángulo
    mov x0, #1
    ldr x1, =space
    mov w20, #4          // rows
    sub w20, w20, w19    // rows - i
spaces_loop1:
    cmp w20, #0
    b.le print_tri1
    mov x2, #1
    mov x8, #64
    svc #0
    sub w20, w20, #1
    b spaces_loop1

print_tri1:
    mov w21, #0          // j = 0
    lsl w22, w19, #1     // i*2
    sub w22, w22, #1     // i*2-1
tri_chars_loop1:
    cmp w21, w22
    b.ge spaces_between
    mov x0, #1
    ldr x1, =tri_char
    mov x2, #3
    mov x8, #64
    svc #0
    add w21, w21, #1
    b tri_chars_loop1

    // Espacio entre triángulos
    // Equivalente a: printf("%*s", (rows-i)*2+1, "")
spaces_between:
    mov w23, #4          // rows
    sub w23, w23, w19    // rows - i
    lsl w23, w23, #1     // (rows-i)*2
    add w23, w23, #1     // +1
spaces_loop2:
    cmp w23, #0
    b.le print_tri2
    mov x0, #1
    ldr x1, =space
    mov x2, #1
    mov x8, #64
    svc #0
    sub w23, w23, #1
    b spaces_loop2

    // Segundo triángulo
print_tri2:
    mov w21, #0          // j = 0
    lsl w22, w19, #1     // i*2
    sub w22, w22, #1     // i*2-1
tri_chars_loop2:
    cmp w21, w22
    b.ge next_bottom_row
    mov x0, #1
    ldr x1, =tri_char
    mov x2, #3
    mov x8, #64
    svc #0
    add w21, w21, #1
    b tri_chars_loop2

next_bottom_row:
    // Nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    add w19, w19, #1
    b bottom_loop

end:
    // Salir
    mov x0, #0
    mov x8, #93
    svc #0
