// --------------------------------------------------------------
// Nombre: reverse_string_arm64.s
// Autor: César González Salazar
// Fecha: 09/abril/2025
// Descripción: Invierte una cadena ingresada por el usuario (ARM64)
// --------------------------------------------------------------

.section .data
prompt:     .asciz "Ingrese una cadena: "
result:     .asciz "\nCadena invertida: "
buffer:     .skip 256      // Buffer para entrada de usuario
reversed:   .skip 256      // Buffer para cadena invertida

.section .text
.global _start

_start:
    // Mostrar prompt
    mov x0, #1            // stdout
    ldr x1, =prompt
    mov x2, #19           // Longitud del prompt
    mov x8, #64           // sys_write
    svc #0

    // Leer entrada de usuario
    mov x0, #0            // stdin
    ldr x1, =buffer
    mov x2, #255          // Máximo 255 caracteres
    mov x8, #63           // sys_read
    svc #0

    // Guardar longitud de la cadena (excluyendo newline)
    mov x19, x0           // x19 = longitud original
    sub x19, x19, #1      // Excluir el newline final

    // Invertir la cadena
    ldr x0, =buffer       // x0 = inicio cadena original
    ldr x1, =reversed     // x1 = inicio buffer invertido
    mov x2, x19           // x2 = longitud

    // Calcular posición final
    add x3, x0, x2        // x3 = final de cadena original
    sub x3, x3, #1        // Ajustar para último carácter

reverse_loop:
    cmp x2, #0
    b.le reverse_done      // Si longitud <= 0, terminar

    ldrb w4, [x3], #-1    // Cargar carácter y decrementar
    strb w4, [x1], #1     // Almacenar en buffer invertido

    sub x2, x2, #1        // Decrementar contador
    b reverse_loop

reverse_done:
    // Añadir null terminator
    mov w4, #0
    strb w4, [x1]

    // Mostrar resultado
    mov x0, #1
    ldr x1, =result
    mov x2, #18           // Longitud del mensaje
    mov x8, #64
    svc #0

    // Mostrar cadena invertida
    mov x0, #1
    ldr x1, =reversed
    mov x2, x19           // Longitud original
    mov x8, #64
    svc #0

    // Añadir newline
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    svc #0

    // Salir
    mov x0, #0
    mov x8, #93
    svc #0

.section .data
newline:    .asciz "\n"
