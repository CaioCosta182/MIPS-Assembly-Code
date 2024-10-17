.data
    prompt_casos: .asciiz "Digite o número de casos de teste: "
    prompt_vagoes: .asciiz "Digite a quantidade de vagões: "
    msg_uma_troca: .asciiz "1 Troca\n"
    msg_multiplas_trocas: .asciiz " Trocas\n"
    casos: .word 0
    vagoes: .word 0
    arr: .space 400  # Espaço para armazenar até 100 vagões
    buffer: .space 16  # Buffer para conversão de número para string

.text
.globl main
main:
    # Leia o número de casos de teste
    li $v0, 4
    la $a0, prompt_casos
    syscall

    li $v0, 5
    syscall
    move $t0, $v0  # Número de casos de teste
    sw $t0, casos

loop_casos:
    # Verifique se há mais casos de teste
    lw $t0, casos
    beqz $t0, sair_programa

    # Leia a quantidade de vagões
    li $v0, 4
    la $a0, prompt_vagoes
    syscall

    li $v0, 5
    syscall
    move $t1, $v0  # Quantidade de vagões
    sw $t1, vagoes

    # Leia a permutação dos vagões
    li $t2, 0          # Índice do vetor
    
ler_vagoes:
    lw $t1, vagoes
    bge $t2, $t1, inicio_sort

    li $v0, 5
    syscall
    sll $t3, $t2, 2  # Calcula o offset (t2 * 4)
    sw $v0, arr($t3)  # Armazena o vagão na posição correta

    addi $t2, $t2, 1  # Próxima posição
    j ler_vagoes

inicio_sort:
    # Início do Selection Sort
    li $t3, 0          # Contador de trocas
    li $t4, 0          # Índice do loop externo
    lw $t5, vagoes     # Número total de vagões

selection_sort_laco_externo:
    bge $t4, $t5, print_resultado  # Se o índice externo >= quantidade de vagões, saia

    # Inicializa o índice do menor valor
    move $t6, $t4      # Índice do menor valor
    addi $t7, $t4, 1   # Índice para verificar os próximos valores

selection_sort_laco_interno:
    bge $t7, $t5, finalizar_inner
    sll $t8, $t6, 2    # Calcula o offset (t6 * 4)
    lw $t9, arr($t8)   # Valor do menor índice
    sll $t0, $t7, 2    # Calcula o offset (t7 * 4)
    lw $t1, arr($t0)   # Valor do próximo índice
    ble $t9, $t1, continue_inner  # Se o valor atual <= próximo, continue

    # Atualiza o índice do menor valor
    move $t6, $t7

continue_inner:
    addi $t7, $t7, 1
    j selection_sort_laco_interno

finalizar_inner:
    beq $t6, $t4, continue_outer

    # Troca o valor encontrado com o valor na posição atual
    sll $t8, $t4, 2    # Calcula o offset (t4 * 4)
    lw $t9, arr($t8)
    sll $t0, $t6, 2    # Calcula o offset (t6 * 4)
    lw $t1, arr($t0)
    sw $t1, arr($t8)
    sw $t9, arr($t0)

    # Incrementa o contador de trocas
    addi $t3, $t3, 1

continue_outer:
    addi $t4, $t4, 1
    j selection_sort_laco_externo

print_resultado:
    # Imprime o número de trocas como uma string
    li $v0, 1          # Código de syscall para imprimir inteiro
    move $a0, $t3      # Número de trocas
    syscall

    # Imprime a mensagem de trocas
    li $v0, 4
    la $a0, msg_multiplas_trocas
    syscall
    j new_case

print_uma_troca:
    li $v0, 4
    la $a0, msg_uma_troca
    syscall
    j new_case

new_case:
    # Decrementa o número de casos
    lw $t0, casos
    addi $t0, $t0, -1
    sw $t0, casos

    # Volta ao início do loop de casos
    j loop_casos

sair_programa:
    li $v0, 10
    syscall
