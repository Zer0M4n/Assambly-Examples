//======================================================
// Nombre del archivo : and_operation_fixed.s
// Autor              : CESAR GONZALEZ SALAZR 
// Fecha              : 10/abril/2025
// Descripción        : Realiza operación AND entre dos números (versión corregida)
// Ensamblador        : GNU as (ARM64) para Raspberry Pi OS
//======================================================

.global _start

.section .data
    num1:       .word 0b1100    // Primer número (12 en binario)
    num2:       .word 0b1010    // Segundo número (10 en binario)
    result:     .word 0         // Para almacenar el resultado
    msg:        .asciz "El resultado de AND es: "
    newline:    .asciz "\n"

.section .text
_start:
    // Cargar direcciones de los números
    adr x4, num1        // x4 = dirección de num1
    adr x5, num2        // x5 = dirección de num2
    adr x6, result      // x6 = dirección de result

    // Cargar los valores desde memoria
    ldr w1, [x4]        // w1 = primer número
    ldr w2, [x5]        // w2 = segundo número

    // Realizar operación AND
    and w3, w1, w2      // w3 = w1 AND w2

    // Guardar resultado
    str w3, [x6]        // Almacenar resultado en memoria

    // Imprimir mensaje
    adr x0, msg
    bl print_string

    // Imprimir resultado (en decimal)
    ldr w0, [x6]        // Cargar resultado para imprimir
    bl print_number

    // Imprimir nueva línea
    adr x0, newline
    bl print_string

    // Salir del programa
    mov x0, #0          // Código de salida 0
    mov x8, #93         // Número de llamada al sistema para exit
    svc 0

// Subrutina para imprimir cadena
// x0: dirección de la cadena terminada en null
print_string:
    mov x2, #0          // Contador de longitud
1:
    ldrb w1, [x0, x2]   // Cargar byte actual
    cbz w1, 2f          // Si es null, terminar
    add x2, x2, #1      // Incrementar contador
    b 1b
2:
    mov x1, x0          // Dirección de la cadena
    mov x0, #1          // Descriptor de archivo (stdout)
    mov x8, #64         // Número de llamada al sistema para write
    svc 0
    ret

// Subrutina para imprimir número (0-9)
// w0: número a imprimir
print_number:
    // Convertir dígito a ASCII
    add w0, w0, #48     // Convertir a ASCII
    // Almacenar en stack
    str x0, [sp, #-16]!
    // Imprimir
    mov x1, sp          // Dirección del carácter
    mov x0, #1          // stdout
    mov x2, #1          // longitud 1
    mov x8, #64         // syscall write
    svc 0
    // Restaurar stack
    add sp, sp, #16
    ret
