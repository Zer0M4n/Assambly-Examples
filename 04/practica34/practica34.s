// =====================================================
// Archivo: contar_vocales.s
// Descripción: Cuenta cuántas vocales hay en la entrada del usuario
// Autor: CESAR GONZALEZ SALAZAR
// Fecha: 09-04-2025
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// int main() {
//     char buf[100];
//     int count = 0;
//     int len = read(0, buf, 100);
//     for (int i = 0; i < len; i++) {
//         if (buf[i]=='a'||buf[i]=='e'||buf[i]=='i'||buf[i]=='o'||buf[i]=='u')
//             count++;
//     }
//     printf("%d\n", count);
//     return 0;
// }
.section .bss
buffer: .skip 100
resultado: .skip 16

.section .text
.global _start

_start:
    // Leer hasta 100 caracteres
    mov x0, #0
    ldr x1, =buffer
    mov x2, #100
    mov x8, #63         // syscall: read
    svc #0
    mov x20, x0         // x20 = longitud
    mov x21, #0         // x21 = contador de vocales
    ldr x22, =buffer    // x22 = puntero al buffer

.loop:
    cmp x20, #0
    beq .done

    ldrb w0, [x22], #1  // w0 = carácter actual
    mov w1, w0          // copiar para comparar

    // Comparar contra vocales minúsculas
    cmp w1, #'a'
    beq .inc
    cmp w1, #'e'
    beq .inc
    cmp w1, #'i'
    beq .inc
    cmp w1, #'o'
    beq .inc
    cmp w1, #'u'
    beq .inc
    b .skip

.inc:
    add x21, x21, #1    // contador++

.skip:
    sub x20, x20, #1
    b .loop

.done:
    // Convertir x21 (contador de vocales) a texto
    mov x0, x21
    ldr x1, =resultado
    bl itoa

    // Agregar salto de línea
    ldr x2, =resultado
.find_end:
    ldrb w3, [x2], #1
    cmp w3, #0
    b.ne .find_end
    mov w3, #'\n'
    strb w3, [x2]

    // Calcular longitud
    ldr x0, =resultado
    mov x1, x0
.len_loop:
    ldrb w2, [x1], #1
    cmp w2, #0
    b.ne .len_loop
    sub x2, x1, x0
    add x2, x2, #1

    // Imprimir resultado
    mov x0, #1
    ldr x1, =resultado
    mov x8, #64
    svc #0

    // Salir
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// itoa
// ==========================
itoa:
    mov x2, #10
    add x3, x1, #15
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
    mov x5, x4
    sub x2, x5, x3
    mov x6, x2
.copy_ascii:
    ldrb w7, [x3], #1
    strb w7, [x1], #1
    subs x6, x6, #1
    b.ne .copy_ascii
    mov w7, #0
    strb w7, [x1]
    ret
