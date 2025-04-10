/************************************************************
 * Autor: Cesar Gonzalez Salazar
 * Fecha: 9 de abril de 2025
 * Descripción: Suma todos los números del 1 al 100
 * y devuelve el resultado como código de salida
 * (exit code del proceso)
 ************************************************************/
.section .text
.global _start

_start:
    mov x0, #0              // x0 será nuestra suma total
    mov x1, #1              // x1 = contador = 1

bucle:
    cmp x1, #101            // ¿ya llegamos a 101?
    b.eq fin                // Si sí, terminamos

    add x0, x0, x1          // suma = suma + i
    add x1, x1, #1          // i++

    b bucle                 // repetir

fin:
    // Salimos y regresamos la suma como código de salida
    mov x8, #93             // syscall número para exit
    svc #0
