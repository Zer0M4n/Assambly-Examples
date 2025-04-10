// --------------------------------------------------------------
// Nombre: clear_screen_arm64.s
// Autor: César González Salazar
// Fecha: 09/abril/2025
// Descripción: Limpia la pantalla en terminales ANSI (ARM64)
// --------------------------------------------------------------

.section .data
// Secuencia ANSI para limpiar pantalla y mover cursor al inicio
clear_seq:  .byte 0x1B     // Carácter de escape
            .byte '['       // Corchete izquierdo
            .byte '2'       // Comando para limpiar pantalla completa
            .byte 'J'       // J = limpiar pantalla
            .byte 0x1B      // Otro carácter de escape
            .byte '['       // Corchete izquierdo
            .byte 'H'       // Mover cursor a posición inicial
            .byte 0         // Null terminator

.section .text
.global _start

_start:
    // Imprimir secuencia ANSI para limpiar pantalla
    mov x0, #1            // stdout
    adr x1, clear_seq     // Cargar dirección de la secuencia
    mov x2, #7            // Longitud de la secuencia (7 bytes)
    mov x8, #64           // sys_write
    svc #0

    // Salir del programa
    mov x0, #0            // Código de salida 0
    mov x8, #93           // sys_exit
    svc #0
