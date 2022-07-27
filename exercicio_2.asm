	.data
vetor1:	.word	9, 8, 7, 6, 5, 4, 3, 2, 1
vetor2: .word	-10, 8, 11, 16, 15, -6, 22
	.text
	
main:
	la 	a0, vetor1
	li 	a1, 8
	li 	a2, 0
	jal	shift
parte2:	
	la 	a0, vetor2
	li 	a1, 5
	li 	a2, 1
	
	add t5, zero, a1 # Salvar ultima posicao q deve ser trocada
	
	jal	shift
termina:
	li 	a7, 10   # chamada de sistema para encerrar programa
	ecall 

#####################################
# Implemente a função abaixo

shift: 
	add t3, zero, zero # zerar variavel t3
	add t0, zero, a0 # armazenar em t0 a posicao inicial de a0
	addi a3, zero, 4 # carregar 4 em a a3
	
	# encotrar valor de a1 e posicao no vetor
	mul a4, a1, a3 # multiplica a1 por a3 (4 Bits) para pegar a posicao na memoria de a1
	add t0, t0, a4 # adiciona a4 no vetor para ir para a posicao de a1
	lw s3, 0(t0) # carregar valor de a1 em s3
	
	add t4, zero, s3 # gravar valor de a1
	
	# econtrar o valor de a2 e posicao no vetor
	add t0, zero, a0 # Reniciar posicao de t0
	mul a4, a2, a3 # multiplica a1 por a3 (4 Bits) para pegar a posicao na memoria de a1
	add t0, t0, a4 # adiciona a4 no vetor para ir para a posicao de a1
	lw s4, 0(t0) # carregar valor de a2 em s4
	j inicializa_vetor
	
fim: 
	j parte2
		
inicializa_vetor:
	add s0, zero, zero #contador para o indice do vetor
	add s1, zero, zero #variavel para ver quantas posicoes mover para chegar no inicio do laco
	add a3, s0, zero  #contador do laco
	add a0, a0, s1 # mover a0 em s1 bits
	addi a7, zero, 9 #armazena ultima pos + 1
	
percorre_vetor:
	lw t2, 0(a0) #carrega valor atual do vetor em t2 (p/ vizualizar)
	beq s0, a7, fim # verifica se vetor chegou ao fim
	beq t2, s4, troca # verifica se t2 e igual a s4(valor de a2) e faz a troca
	beq t3, t2, troca # verifica se t3 e igual a valor substituido anteriormente
	
continue:
	addi s0, s0, 1 # Contador + 1
	addi s1, zero, 4 # Auxiliar da posicao + 4
	add a0, a0, s1 # Pessa a proxima posicao do vetor (i++)
	j percorre_vetor
	
troca:
	lw t3, 0(a0) # armzenar valor do que vai ser trocado
	sw s3, (a0) # troca o valor de a0 pelo valor em s3
	
	beq t3, t4, mais4
	add s3, zero, t3 # armazena o valor substituido para ser o proximo a trocar
	lw t3, 4(a0) # adicionar em t3 o proximo valor
	j continue
	
mais4:
	beq s0, t5, termina # verifica se esta na posicao que foi colocada em outra
	j continue
