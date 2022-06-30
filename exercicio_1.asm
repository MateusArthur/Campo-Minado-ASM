	.data
vetor1:	.word	9, 8, 7, 6, 5, 4, 3, 2, 1
vetor2: .word	-10, 8, 11, 16, 15, -6, 22
	.text
	
main:
	la 	a0, vetor1
	li 	a1, 8
	li 	a2, 0
	#jal	swap
	jal	shift
	
	la 	a0, vetor2
	li 	a1, 5
	li 	a2, 1
	#jal	swap
	jal	shift

	li 	a7, 10   # chamada de sistema para encerrar programa
	ecall 
	
#####################################
# Implemente a função abaixo
swap:
	add t0, zero, a0 # armazenar em t0 a posicao inicial de a0
	addi a3, zero, 4 # carregar 4 em a a3
	
	# encotrar valor de a2 e posicao no vetor
	mul a5, a2, a3 # multiplica a2 por a3 (4 Bits) para pegar a posicao na memoria de a2
	add t0, t0, a5 # adiciona a5 no vetor para ir para a posicao de a2
	lw s2, 0(t0) # carregar valor de a2 em s2
	
	# encontrar valor a1 e posicao no vetor
	mul a4, a1, a3 # multiplica a1 por a3 (4) para pegar a posicao de a1
	add a0, a0, a4 # adiciona a4 no vetor para ir para a posicao de a1
	lw s1, 0(a0) # carregar valor de a1 em s1
	
	sw s2, (a0)  # colocar valor de a2 em a1
	
	add a0, zero, t0 # carregar a posicao de memoria de a2 no vetor a0
	sw s1, (a0) # salvar em a1 em a2
	
	ret
	
shift:

	ret