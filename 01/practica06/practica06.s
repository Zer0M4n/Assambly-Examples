//======================================================
// Nombre del archivo : rombo.s
// Autor              : Tu Nombre Aquí
// Fecha              : 10/abril/2025
// Descripción        : Imprime un rombo de asteriscos
// Ensamblador        : GNU as (ARM64) para Raspberry Pi OS
//======================================================

.global _start

.section .data
    asterisco:    .asciz "*"
    espacio:      .asciz " "
    nueva_linea:  .asciz "\n"
    tamano:       .byte 3        // Controla el tamaño del rombo

.section .text
_start:
    // Cargar tamaño
    adr x19, tamano
    ldrb w20, [x19]             // w20 = tamaño

    // Mitad superior del rombo
    mov w21, #1                  // w21 = asteriscos actuales
    mov w22, w20                 // w22 = espacios actuales

    superior:
        // Imprimir espacios
        cbz w22, imprimir_linea_sup
        mov w23, w22
        espacios_sup:
            ldr x0, =espacio
            bl imprimir_cadena
            sub w23, w23, #1
            cbnz w23, espacios_sup

        imprimir_linea_sup:
            // Imprimir asteriscos
            mov w23, w21
            asteriscos_sup:
                ldr x0, =asterisco
                bl imprimir_cadena
                sub w23, w23, #1
                cbnz w23, asteriscos_sup

            // Nueva línea
            ldr x0, =nueva_linea
            bl imprimir_cadena

            // Actualizar contadores
            add w21, w21, #2
            sub w22, w22, #1
            cmp w22, #0
            bge superior

    // Mitad inferior del rombo
    sub w21, w21, #4
    mov w22, #1

    inferior:
        // Imprimir espacios
        mov w23, w22
        espacios_inf:
            ldr x0, =espacio
            bl imprimir_cadena
            sub w23, w23, #1
            cbnz w23, espacios_inf

        // Imprimir asteriscos
        mov w23, w21
        asteriscos_inf:
            ldr x0, =asterisco
            bl imprimir_cadena
            sub w23, w23, #1
            cbnz w23, asteriscos_inf

        // Nueva línea
        ldr x0, =nueva_linea
        bl imprimir_cadena

        // Actualizar contadores
        sub w21, w21, #2
        add w22, w22, #1
        cmp w21, #0
        bgt inferior

    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0

// Subrutina para imprimir una cadena
imprimir_cadena:
    mov x2, #0
1:  ldrb w1, [x0, x2]
    cbz w1, 2f
    add x2, x2, #1
    b 1b
2:  mov x1, x0
    mov x0, #1
    mov x8, #64
    svc 0
    ret
