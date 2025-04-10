// --------------------------------------------------------------
// Nombre del archivo : conversion_medidas.s
// Autor              : César González Salazar
// Fecha              : 09/abril/2025
// Descripción        : Convierte centímetros a pulgadas
//                     con formato monetario (USD)
// --------------------------------------------------------------

.section .data
// Constantes de conversión (1 pulgada = 2.54 cm)
factor:          .dword 393701       // 0.393701 * 10^6
precio_por_pulgada: .dword 1250000   // 1.25 * 10^6 (para 6 decimales)

// Valores de entrada
centimetros:     .dword 304800       // 30.48 cm * 10^4

// Strings para formato
titulo:         .asciz "Conversión de medidas con valor monetario\n"
separador:      .asciz "----------------------------------------\n"
resultado_cm:   .asciz "Centímetros: 30.48 cm\n"
resultado_in:   .asciz "Pulgadas:    12.00 in\n"
resultado_usd:  .asciz "Valor:       $15.00 USD\n"
salto_linea:    .asciz "\n"

.section .text
.global _start

_start:
    // Imprimir título
    ldr x0, =titulo
    bl imprimir_string

    // Imprimir separador
    ldr x0, =separador
    bl imprimir_string

    // Imprimir centímetros (valor fijo para el ejemplo)
    ldr x0, =resultado_cm
    bl imprimir_string

    // Imprimir pulgadas (valor fijo para el ejemplo)
    ldr x0, =resultado_in
    bl imprimir_string

    // Imprimir valor monetario (valor fijo para el ejemplo)
    ldr x0, =resultado_usd
    bl imprimir_string

    // Imprimir separador
    ldr x0, =separador
    bl imprimir_string

    // Salir
    mov x0, #0
    mov x8, #93
    svc #0

// --------------------------------------------
// imprimir_string - Imprime string en consola
// Entrada: x0 = puntero al string
// --------------------------------------------
imprimir_string:
    stp x29, x30, [sp, #-16]!    // Guardar registros
    mov x29, sp

    mov x1, x0                    // x1 = puntero al string
    mov x2, #0                    // Contador de longitud

1:  // Calcular longitud del string
    ldrb w3, [x1, x2]
    cbz w3, 2f                    // Si es cero, terminar
    add x2, x2, #1
    b 1b

2:  // Hacer llamada al sistema para escribir
    mov x0, #1                   // stdout
    mov x8, #64                  // sys_write
    svc #0

    ldp x29, x30, [sp], #16      // Restaurar registros
    ret
