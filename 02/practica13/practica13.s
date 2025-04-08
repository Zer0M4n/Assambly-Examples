// =====================================================
// Archivo: factorial.s
// Descripción: Calcula el factorial de 5 (5! = 120)
// Autor: [Cesar Gonzalez Salazar]
// Fecha: [08-04-2025]
// Plataforma: Raspberry Pi OS 64-bit (ARM64/AArch64)
// =====================================================
// rust code
//fn main() {
//    let mut resultado = 1;
//
//    for i in 1..=5 {
//        resultado *= i;
//    }
//
//    println!("{}", resultado);
//}
//
.section .data
buffer: .skip 16      // Espacio para guardar el resultado como string

.section .text
.global _start

_start:
    mov x0, #1         // x0 = i
    mov x1, #1         // x1 = resultado (factorial acumulado)

bucle:
    cmp x0, #5
    b.gt convertir     // Si i > 5, termina bucle

    mul x1, x1, x0     // resultado *= i
    add x0, x0, #1     // i++

    b bucle

// ------------------------
// Convertir x1 (resultado) a cadena ASCII en buffer
// ------------------------
convertir:
    adr x3, buffer
    add x4, x3, #15    // x4 = buffer + 15
    mov x5, #10        // divisor

conv_loop:
    mov x6, x1
    udiv x1, x1, x5
    msub x7, x1, x5, x6
    add x7, x7, #'0'
    sub x4, x4, #1
    strb w7, [x4]
    cmp x1, #0
    b.ne conv_loop

// ------------------------
// Imprimir resultado en consola
// ------------------------
    mov x0, #1         // stdout
    mov x1, x4         // inicio del número en buffer
    adr x3, buffer
    add x2, x3, #15
    sub x2, x2, x4     // longitud del texto
    mov x8, #64        // syscall write
    svc #0

// ------------------------
// Salida limpia del programa
// ------------------------
    mov x0, #0
    mov x8, #93
    svc #0
