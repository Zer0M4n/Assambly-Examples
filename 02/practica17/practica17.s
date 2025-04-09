// =====================================================
// Archivo: contar_caracteres.s
// Descripción: Cuenta cuántos caracteres escribió el usuario
// Autor: [Cesar Gonzalez Salaazar]
// Fecha: [08-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================

.section .bss
buffer: .skip 100
msg:    .skip 64            // Mensaje de salida completo

.section .rodata
texto:
    .ascii "Escribiste "

.section .text
.global _start

_start:
    // Leer entrada del usuario
    mov x0, #0              // stdin
    ldr x1, =buffer
    mov x2, #100
    mov x8, #63             // syscall: read
    svc #0
    mov x3, x0              // guardar longitud leída en x3

    // Copiar "Escribiste " al inicio de msg
    ldr x4, =msg
    ldr x5, =texto
    mov x6, #11             // longitud de "Escribiste "
.copy_text:
    ldrb w7, [x5], #1
    strb w7, [x4], #1
    subs x6, x6, #1
    b.ne .copy_text

    // Convertir número a ASCII y ponerlo después del texto
    mov x0, x3              // x0 = número leído
    mov x1, x4              // x4 ya apunta donde terminó el texto
    bl itoa                 // itoa escribe en x1

    // x1 ahora apunta justo después del número → escribir '\n'
    mov w2, #'\n'
    strb w2, [x1]           // agrega salto de línea
    add x1, x1, #1
    mov w2, #0
    strb w2, [x1]           // null terminator (por si acaso)

    // Calcular longitud del mensaje para imprimir
    ldr x0, =msg
    mov x1, x0
.find_len:
    ldrb w2, [x1], #1
    cmp w2, #0
    b.ne .find_len
    sub x2, x1, x0          // x2 = longitud del mensaje

    // Escribir mensaje
    mov x0, #1              // stdout
    ldr x1, =msg
    mov x8, #64             // syscall: write
    svc #0

    // Salida limpia
    mov x0, #0
    mov x8, #93             // syscall: exit
    svc #0

// ==========================
// itoa: convierte entero a string ASCII
// Entrada: x0 = número, x1 = buffer destino
// Salida: x1 actualizado al final del string
// ==========================
itoa:
    mov x2, #10
    add x3, x1, #15         // puntero final temporal
    mov x4, x3

.itoa_loop:
    udiv x5, x0, x2
    msub x6, x5, x2, x0
    add x6, x6, #'0'
    sub x3, x3, #1
    strb w6, [x3]
    mov x0, x5
    cmp x0, #0
    b.ne .itoa_loop

    // Copiar desde x3 → x1 (destino)
    mov x5, x4
    sub x2, x5, x3
    mov x6, x2
.copy_digits:
    ldrb w7, [x3], #1
    strb w7, [x1], #1
    subs x6, x6, #1
    b.ne .copy_digits

    mov x0, x1              // devolver nuevo puntero final en x0
    ret
