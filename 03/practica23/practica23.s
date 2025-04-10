// ------------------------------------------------------------------
// Nombre del archivo : decimal_a_binario.s
// Autor              : [CESAR GONZALEZ SALAZAR]
// Fecha              : 09/abril/2025
// Descripción        : Convierte un número decimal a binario (string)
// Plataforma         : Raspberry Pi OS 64-bit (Raspbian Linux)
// Arquitectura       : ARM64 (AArch64)
// Ensamblador        : GNU as (as), enlazador ld
// Ejecutar con       : as -o decimal_a_binario.o decimal_a_binario.s
//                      ld -o decimal_a_binario decimal_a_binario.o
//                      ./decimal_a_binario
// ------------------------------------------------------------------

// Código C# equivalente:
// int n = 13;
// string bin = Convert.ToString(n, 2);
// Console.WriteLine(bin);  // "1101"

.section .data
titulo:         .asciz "Binario: "
salto_linea:    .asciz "\n"
buffer_bin:     .skip 65  // buffer de 64 bits + '\0'

.section .text
.global _start

_start:
    // Número a convertir
    mov     x0, #13           // número decimal
    ldr     x1, =buffer_bin   // dirección del buffer
    bl      decimal_a_bin     // llamada a subrutina

    // Mostrar título
    mov     x0, #1
    ldr     x1, =titulo
    mov     x2, #9
    mov     x8, #64
    svc     #0

    // Mostrar binario
    mov     x0, #1
    ldr     x1, =buffer_bin
    mov     x2, #4            // longitud "1101"
    mov     x8, #64
    svc     #0

    // Mostrar salto de línea
    mov     x0, #1
    ldr     x1, =salto_linea
    mov     x2, #1
    mov     x8, #64
    svc     #0

    // Salir
    mov     x0, #0
    mov     x8, #93
    svc     #0

// -----------------------------------------------------
// Subrutina: decimal_a_bin
// Entrada : x0 = número decimal
// Salida  : x1 = buffer donde se guarda la cadena binaria
// Usa     : x2, x3, x4
// -----------------------------------------------------
decimal_a_bin:
    mov     x2, #0             // contador de bits
    mov     x3, x0             // copia del número
    add     x1, x1, #64        // mover al final del buffer
    mov     x4, #0             // byte nulo
    strb    w4, [x1]           // escribir null terminator
    sub     x1, x1, #1         // ir al byte anterior

loop_bin:
    and     x4, x3, #1         // extraer bit menos significativo
    add     x4, x4, #'0'       // convertir a ASCII
    strb    w4, [x1]           // guardar carácter en buffer
    lsr     x3, x3, #1         // desplazar derecha
    sub     x1, x1, #1         // mover atrás en buffer
    add     x2, x2, #1         // contador++

    cmp     x3, #0
    b.ne    loop_bin

    add     x1, x1, #1         // apuntar al primer carácter válido
    ret
