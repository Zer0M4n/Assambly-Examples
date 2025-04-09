// =====================================================
// Archivo: suma_interactiva.s
// Descripción: Lee dos números desde teclado, los suma y muestra el resultado
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [08-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// code c
// int main() {
//     char buf1[10], buf2[10];
//     int a, b;
//     read(0, buf1, 10);
//     read(0, buf2, 10);
//     a = atoi(buf1);
//     b = atoi(buf2);
//     printf("%d\n", a + b);
//     return 0;
// }
.section .bss
buf1:   .skip 10
buf2:   .skip 10
outbuf: .skip 16

.section .text
.global _start

_start:
    // Leer primer número
    mov x0, #0            // stdin
    ldr x1, =buf1         // dirección de buf1
    mov x2, #10           // hasta 10 caracteres
    mov x8, #63           // syscall: read
    svc #0

    // Convertir buf1 a entero → x3
    ldr x1, =buf1
    bl atoi
    mov x3, x0

    // Leer segundo número
    mov x0, #0
    ldr x1, =buf2
    mov x2, #10
    mov x8, #63
    svc #0

    // Convertir buf2 a entero → x4
    ldr x1, =buf2
    bl atoi
    mov x4, x0

    // Sumar
    add x0, x3, x4         // x0 = resultado

    // Convertir a string (x0 = número, x1 = destino)
    ldr x1, =outbuf
    bl itoa                // imprime también

    // Agregar salto de línea '\n'
    ldr x2, =outbuf
.agrega_nl:
    ldrb w3, [x2]
    cmp w3, #0
    beq .poner_nl
    add x2, x2, #1
    b .agrega_nl
.poner_nl:
    mov w3, #'\n'
    strb w3, [x2]

    // Imprimir resultado
    mov x0, #1            // stdout
    ldr x1, =outbuf
    sub x2, x2, x1        // longitud hasta \n
    add x2, x2, #1        // incluir '\n'
    mov x8, #64           // syscall: write
    svc #0

    // exit(0)
    mov x0, #0
    mov x8, #93
    svc #0

// ==========================
// atoi: ASCII -> int
// Entrada: x1 = puntero a string
// Salida: x0 = número entero
// ==========================
atoi:
    mov x0, #0            // resultado
    mov x7, #10           // base 10

.atoi_loop:
    ldrb w2, [x1], #1     // leer byte
    cmp w2, #'0'
    blt .atoi_done
    cmp w2, #'9'
    bgt .atoi_done
    sub w2, w2, #'0'      // ASCII → num
    mul x0, x0, x7        // x0 *= 10
    add x0, x0, x2        // x0 += dígito
    b .atoi_loop

.atoi_done:
    ret

// ==========================
// itoa: int -> ASCII string
// Entrada: x0 = número, x1 = buffer destino
// Salida: escribe número en texto en buffer
// ==========================
itoa:
    mov x2, #10
    add x3, x1, #15       // puntero final
    mov x4, x3            // guardar final para calcular longitud

.itoa_loop:
    udiv x5, x0, x2       // x5 = x0 / 10
    msub x6, x5, x2, x0   // x6 = x0 - x5*10 → residuo
    add x6, x6, #'0'      // a ASCII
    sub x3, x3, #1
    strb w6, [x3]
    mov x0, x5
    cmp x0, #0
    b.ne .itoa_loop

    // Copiar a destino (x1)
    mov x0, x1
    sub x2, x4, x3
    mov x5, x2
.copy_loop:
    ldrb w6, [x3], #1
    strb w6, [x0], #1
    subs x5, x5, #1
    b.ne .copy_loop

    // Terminar string
    mov w6, #0
    strb w6, [x0]

    ret
