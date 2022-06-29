	.data
vetor1:	.word	9, 8, 7, 6, 5, 4, 3, 2, 1
vetor2: .word	-10, 8, 11, 16, 15, -6, 22

	.text
	
main:
	la 	a0, vetor1
	li 	a1, 8
	li 	a2, 0
	jal	swap
	
	la 	a0, vetor2
	li 	a1, 5
	li 	a2, 1
	jal	swap

	li 	a7, 10   # chamada de sistema para encerrar programa
	ecall 
	
#####################################
# Implemente a função abaixo
swap:
	add s5, zero, a0
	add s0, zero, zero #contador para o indice do vetor
	add s1, zero, zero #variavel para ver quantas posicoes mover para chegar no inicio do laco
	add a3, s0, zero  #contador do laco
	add a0, a0, s1
	addi a7, zero, 9 #armazena ultima pos
	j percorre

percorre:
	lw t2, 0(a0) #carrega valor atual do vetor em t2 (p/ vizualizar)
	beq s0, a7, newloop
	beq s0, a1, salvarvalor # verfica se o id do indice e o mesmo que estamos procurando
	beq s0, a2, salvarvalor2 # verfica se o id do indice e o mesmo que estamos procurando
	addi s0, s0, 1 # Contador + 1
	addi s1, zero, 4 # Auxiliar da posicao + 4
	add a0, a0, s1 # Pessa a proxima posicao do vetor (i++)
	j percorre
	
newloop:
	add a0, zero, s5 # voltar para o inicio do vetor
	add s0, zero, zero #contador para o indice do vetor
	add s1, zero, zero #variavel para ver quantas posicoes mover para chegar no inicio do laco
	add a3, s0, zero  #contador do laco
	add a0, a0, s1
	add a5, zero, a4 #Armazenar qual indice quer encontrar
	j percorre
	
loop:
	addi s0, s0, 1 # Contador + 1
	addi s1, zero, 4 # Auxiliar da posicao + 4
	lw t0, 0(a0) #carrega valor atual do vetor em t0
	beq t0, a5, substituir # verfica se o id do indice e o mesmo que estamos procurando
	add a0, a0, s1 # Pessa a proxima posicao do vetor (i++)
	j loop
	
salvarvalor:
	lw t0, 0(a0) #carrega valor atual do vetor em t0
	add a4 zero, t0 # Armazenar valor de t0 em a4
	addi s0, s0, 1 # Contador + 1
	addi s1, zero, 4 # Auxiliar da posicao + 4
	add a0, a0, s1 # Pessa a proxima posicao do vetor (i++)
	j percorre


salvarvalor2:
	lw t0, 0(a0) #carrega valor atual do vetor em t0
	add a6, zero, t0 # Armazenar valor em a6
	addi s0, s0, 1 # Contador + 1
	addi s1, zero, 4 # Auxiliar da posicao + 4
	add a0, a0, s1 # Pessa a proxima posicao do vetor (i++)
	j percorre
	

substituir:
	sw a5, (a0) # substitui o valor no vetor
	beq a5, a6, fim # Verifica se o ultimo valor adicionado foi a6
	add a5, zero, a6 # Adicione a 6
	j loop
	
fim: 
	ret