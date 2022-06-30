	.data
vetor1:	.word	9, 8, 7, 6, 5, 4, 3, 2, 1
vetor2: .word	-10, 8, 11, 16, 15, -6, 22
vetor3:	.word	0, 1, 2, 3, 4, 5, 6, 7 , 8, 9

	.text
	
main:
	la 	a0, vetor1
	li 	a1, 9
	jal	ordena

segunda_parte:
	la 	a0, vetor2
	li 	a1, 7
	jal	ordena

terceira_parte:
	la 	a0, vetor3
	li 	a1, 10
	jal	ordena
final:
	li 	a7, 10   # chamada de sistema para encerrar programa
	ecall 
	
#####################################
# Implemente a função abaixo	
ordena:
	lw a2, 0(a0) # Define o primeiro como menor
	
	add s0, zero, zero #contador para o indice do vetor
	add s1, zero, zero #variavel para ver quantas posicoes mover para chegar no inicio do laco
	add a3, s0, zero  #contador do laco
	add a0, a0, s1 # mover a0 em s1 bits
	add a7, zero, a1 #armazena ultima pos
	
percorre_vetor:
	lw t2, 0(a0) # t2 = a0[i]
	blt t2, a2, trocar # if(t2 < a2)
	addi s0, s0, 1 # i++
	beq s0, a7, fim # if(s0 = 9)
	addi s1, zero, 4 # Auxiliar da posicao + 4
	add a0, a0, s1 # Passa para a proxima posicao do vetor
	j percorre_vetor # volta do inicio

trocar:
	sw a2, 0(a0)
	sw t2, -4(a0)
	add a1, zero, a0
	add a2, zero, t2
	add s2, zero, s0

percorre_esq:
	beqz s2, voltar_info
	addi s2, s2, -1 # i--
	addi s3, zero, -4 # Auxiliar da posicao + 4
	add a1, a1, s3 # Passa para a posicao anterior posicao do vetor
	lw t2, 0(a1) # t2 = a1[i]
	blt a2, t2, trocar_esq 
	beqz s2, voltar_info
	j percorre_esq
	
trocar_esq:
	sw a2, 0(a1)
	sw t2, 4(a1)
	
	j percorre_esq

voltar_info:
	lw a2, 0(a0)
	j percorre_vetor
	
fim:
	addi s10, s10, 1
	addi s8, zero, 1
	addi s9, zero, 2
	beq s10, s8, segunda_parte
	beq s10, s9, terceira_parte
	j final
	