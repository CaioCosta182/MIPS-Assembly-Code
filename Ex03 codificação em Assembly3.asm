.data
    prompt: .asciiz "Digite um número: "
    msg_sim: .asciiz "Sim\n"
    msg_nao: .asciiz "Não\n"
    num: .word 0
    soma_divisores: .word 0
    i: .word 1
    temp: .word 0
    num_original: .word 0

.text
.globl main
main:
    # Leia o número
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    sw $v0, num

    # Armazene o número original
    lw $t0, num
    sw $t0, num_original

    # Inicialize a soma dos divisores
    li $t1, 0
    sw $t1, soma_divisores

    # Inicialize o índice i
    li $t2, 1
    sw $t2, i

loop_divisores:
    # Carregue i e o número
    lw $t3, i
    lw $t4, num

    # Verifique se i é um divisor
    div $t4, $t3
    mfhi $t5          # Resto da divisão
    beqz $t5, check_divisor

    # Se não for divisor, incremente i e continue
    j increment_i

check_divisor:
    # Adicione i à soma dos divisores
    lw $t6, soma_divisores
    add $t6, $t6, $t3
    sw $t6, soma_divisores

increment_i:
    # Incrementa i
    lw $t7, i
    addi $t7, $t7, 1
    sw $t7, i

    # Verifique se i < num (excluindo o próprio número)
    lw $t8, num
    blt $t7, $t8, loop_divisores

    # Compare a soma dos divisores com o número original
    lw $t9, soma_divisores
    lw $s0, num_original
    beq $t9, $s0, print_sim

    # Se não for igual, imprime "Não"
    li $v0, 4
    la $a0, msg_nao
    syscall
    j exit_program

print_sim:
    # Se for igual, imprime "Sim"
    li $v0, 4
    la $a0, msg_sim
    syscall

exit_program:
    # Saída
    li $v0, 10
    syscall
