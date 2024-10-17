.data
    prompt_h1: .asciiz "Digite a idade do primeiro homem: "
    prompt_h2: .asciiz "Digite a idade do segundo homem: "
    prompt_m1: .asciiz "Digite a idade da primeira mulher: "
    prompt_m2: .asciiz "Digite a idade da segunda mulher: "
    resultado_soma: .asciiz "A soma das idades do homem mais velho com a mulher mais nova é: "
    resultado_produto: .asciiz "O produto das idades do homem mais novo com a mulher mais velha é: "
    idade_h1: .word 0
    idade_h2: .word 0
    idade_m1: .word 0
    idade_m2: .word 0
    novaLinha: .asciiz "\n"

.text
.globl main
main:
    # Leia a idade do primeiro homem
    li $v0, 4
    la $a0, prompt_h1
    syscall

    li $v0, 5
    syscall
    sw $v0, idade_h1

    # Leia a idade do segundo homem
    li $v0, 4
    la $a0, prompt_h2
    syscall

    li $v0, 5
    syscall
    sw $v0, idade_h2

    # Leia a idade da primeira mulher
    li $v0, 4
    la $a0, prompt_m1
    syscall

    li $v0, 5
    syscall
    sw $v0, idade_m1

    # Leia a idade da segunda mulher
    li $v0, 4
    la $a0, prompt_m2
    syscall

    li $v0, 5
    syscall
    sw $v0, idade_m2

    # Determine o homem mais velho e o mais novo
    lw $t0, idade_h1
    lw $t1, idade_h2
    blt $t0, $t1, set_h1_min
    move $t2, $t0  # max_h
    move $t3, $t1  # min_h
    j determine_mulher

set_h1_min:
    move $t2, $t1  # max_h
    move $t3, $t0  # min_h

determine_mulher:
    # Determine a mulher mais velha e a mais nova
    lw $t4, idade_m1
    lw $t5, idade_m2
    blt $t4, $t5, set_m1_min
    move $t6, $t4  # max_m
    move $t7, $t5  # min_m
    j calcular_resultados

set_m1_min:
    move $t6, $t5  # max_m
    move $t7, $t4  # min_m

calcular_resultados:
    # Calcule a soma do homem mais velho com a mulher mais nova
    add $t8, $t2, $t7

    # Calcule o produto do homem mais novo com a mulher mais velha
    mul $t9, $t3, $t6

    # Imprima o resultado da soma
    li $v0, 4
    la $a0, resultado_soma
    syscall

    li $v0, 1
    move $a0, $t8
    syscall

    # Imprima uma nova linha
    li $v0, 4
    la $a0, novaLinha
    syscall

    # Imprima o resultado do produto
    li $v0, 4
    la $a0, resultado_produto
    syscall

    li $v0, 1
    move $a0, $t9
    syscall

    # Imprima uma nova linha
    li $v0, 4
    la $a0, novaLinha
    syscall

    # Saída
    li $v0, 10
    syscall
