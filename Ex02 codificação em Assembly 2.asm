.data
    prompt: .asciiz "Digite o valor da compra: "
    resultado: .asciiz "Notas usadas para pagar a compra:\n"
    nota10_msg: .asciiz "Notas de 10: "
    nota5_msg: .asciiz "Notas de 5: "
    nota1_msg: .asciiz "Notas de 1: "
    novaLinha: .asciiz "\n"
    valor: .word 0
    nota10: .word 0
    nota5: .word 0
    nota1: .word 0

.text
.globl main
main:
    # Leia o valor da compra
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    sw $v0, valor

    # Inicialize contadores para as notas
    li $t0, 999999          # Quantidade de notas de 10
    li $t1, 999999         # Quantidade de notas de 5
    li $t2, 999999         # Quantidade de notas de 1
    li $t3, 0          # Contador de notas de 10 usadas
    li $t4, 0          # Contador de notas de 5 usadas
    li $t5, 0          # Contador de notas de 1 usadas

    # Carregue o valor da compra
    lw $t6, valor

    # Calcule o número de notas de 10
    li $t7, 10
    div $t6, $t7
    mflo $t8          # Quantidade de notas de 10 necessárias
    mfhi $t6          # Valor restante
    blt $t8, $t0, skip_10_notas
    move $t3, $t0
    move $t6, $t6
    j calcular_5_notas

skip_10_notas:
    move $t3, $t8

calcular_5_notas:
    # Calcule o número de notas de 5
    li $t7, 5
    div $t6, $t7
    mflo $t8          # Quantidade de notas de 5 necessárias
    mfhi $t6          # Valor restante
    blt $t8, $t1, skip_5_notas
    move $t4, $t1
    move $t6, $t6
    j calcular_1_notas

skip_5_notas:
    move $t4, $t8

calcular_1_notas:
    # Calcule o número de notas de 1
    li $t7, 1
    div $t6, $t7
    mflo $t8          # Quantidade de notas de 1 necessárias
    mfhi $t6          # Valor restante
    move $t5, $t8

    # Imprima os resultados
    li $v0, 4
    la $a0, resultado
    syscall

    li $v0, 4
    la $a0, nota10_msg
    syscall
    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

    li $v0, 4
    la $a0, nota5_msg
    syscall
    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

    li $v0, 4
    la $a0, nota1_msg
    syscall
    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

    # Saída
    li $v0, 10
    syscall
