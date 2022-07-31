###############################################################
#A fun��o insere_bombas necessita os seguintes r�tulos
# e espa�os de mem�ria reservados
		.data
campo:			.space		576   # esta vers�o suporta campo de at� 12 x 12 posi��es de mem�ria
salva_S0:		.word		0
salva_ra:		.word		0
salva_ra1:		.word		0

#########################################################
# necess�rio em caso de debug da funcao
#espaco:			.asciz		" "
#dois_pontos:		.asciz		": "
#nova_linha:		.asciz		"\n"
#posicao:		.asciz		"\nPosicao bomba "
#########################################################

	.text

########################################################
# fun��o main somente para teste. N�o deve ser copiada 
#  para o c�digo do trabalho
main:
	la 	a0, campo	# endere�o inicial do campo
	addi	a1, zero, 12	# quantidade de linhas do campo
	jal 	INSERE_BOMBA
	nop
fim:    addi	a7, zero, 10	# encerra o programa
	ecall


############################################################
# A fun��o insere_bombas est� implementada abaixo.
# Todo o c�digo a seguir, mais os rotulos acima deve 
# ser colocado junto ao c�digo do trabalho de campo minado
# entrada: a0 endere�o de memoria do inicio da matriz campo
#          a1 quantidade de linhas da matriz campo
# saida: nao retorna nada
############################################################
#     Algoritmo	
#
#  Salva registradores
#  Carrega numero de sementes sorteadas = 15
#  Le semente para fun��o de numero pseudo randomico
#  while (bombas < x) 
#     sorteia linha
#     sorteia coluna
#     le posi��o pos = (L * tam + C) * 4
#     if(pos != 9)
#    	  grava posicao pos = 9
#     bombas++  
#
############################################################
INSERE_BOMBA:
		la	t0, salva_S0
		sw  	s0, 0 (t0)		# salva conteudo de s0 na memoria
		la	t0, salva_ra
		sw  	ra, 0 (t0)		# salva conteudo de ra na memoria
		
		add 	t0, zero, a0		# salva a0 em t0 - endere�o da matriz campo
		add 	t1, zero, a1		# salva a1 em t1 - quantidade de linhas 

QTD_BOMBAS:
		addi 	t2, zero, 15 		# seta para 15 bombas	
		add 	t3, zero, zero 	# inicia contador de bombas com 0
		addi 	a7, zero, 30 		# ecall 30 pega o tempo do sistema em milisegundos (usado como semente
		ecall 				
		add 	a1, zero, a0		# coloca a semente em a1
INICIO_LACO:
		beq 	t2, t3, FIM_LACO
		add 	a0, zero, t1 		# carrega limite para %	(resto da divis�o)
		jal 	PSEUDO_RAND
		add 	t4, zero, a0		# pega linha sorteada e coloca em t4
		add 	a0, zero, t1 		# carrega limite para % (resto da divis�o)
   		jal 	PSEUDO_RAND
		add 	t5, zero, a0		# pega coluna sorteada e coloca em t5

###############################################################################
# imprime valores na tela (para debug somente) - retirar comentarios para ver
#	
#		li	a7, 4		# mostra texto "Posicao: "
#		la	a0, posicao
#		ecall
#		
#		li	a7, 1		
#		add 	a0, zero, t3 	# imprime quantidade ja sorteada
#		ecall		
#
#		li	a7, 4		# imrpime :
#		la	a0, dois_pontos
#		ecall
#
#		li	a7, 1
#		add 	a0, zero, t4 	# imprime a linha sorteada	
#		ecall
#		
#		li	a7, 4		# imrpime espa�o
#		la	a0, espaco
#		ecall	
#			
#		li	a7, 1
#		add 	a0, zero, t5 	# imprime coluna sorteada
#		ecall
#		
##########################################################################	

LE_POSICAO:	
		mul  	t4, t4, t1
		add  	t4, t4, t5  		# calcula (L * tam) + C
		add  	t4, t4, t4  		# multiplica por 2
		add  	t4, t4, t4  		# multiplica por 4
		add  	t4, t4, t0  		# calcula Base + deslocamento
		lw   	t5, 0(t4)   		# Le posicao de memoria LxC
VERIFICA_BOMBA:		
		addi 	t6, zero, 9		# se posi��o sorteada j� possui bomba
		beq  	t5, t6, PULA_ATRIB	# pula atribui��o 
		sw   	t6, 0(t4)		# sen�o coloca 9 (bomba) na posi��o
		addi 	t3, t3, 1		# incrementa quantidade de bombas sorteadas
PULA_ATRIB:
		j	INICIO_LACO

FIM_LACO:					# recupera registradores salvos
		la	t0, salva_S0
		lw  	s0, 0(t0)		# recupera conteudo de s0 da mem�ria
		la	t0, salva_ra
		lw  	ra, 0(t0)		# recupera conteudo de ra da mem�ria		
		jr 	ra			# retorna para funcao que fez a chamada
		
##################################################################
# PSEUDO_RAND
# fun��o que gera um n�mero pseudo-randomico que ser�
# usado para obter a posi��o da linha e coluna na matriz
# entrada: a0 valor m�ximo do resultado menos 1 
#             (exemplo: a0 = 8 resultado entre 0 e 7)
#          a1 para o n�mero pseudo randomico 
# saida: a0 valor pseudo randomico gerado
#################################################################
#int rand1(int lim, int semente) {
#  static long a = semente; 
#  a = (a * 125) % 2796203; 
#  return (|a % lim|); 
# }  

PSEUDO_RAND:
		addi t6, zero, 125  		# carrega constante t6 = 125
		lui  t5, 682			# carrega constante t5 = 2796203
		addi t5, t5, 1697 		# 
		addi t5, t5, 1034 		# 	
		mul  a1, a1, t6			# a = a * 125
		rem  a1, a1, t5			# a = a % 2796203
		rem  a0, a1, a0			# a % lim
		bge  a0, zero, EH_POSITIVO  	# testa se valor eh positivo
		addi s2, zero, -1           	# caso n�o 
		mul  a0, a0, s2		    	# transforma em positivo
EH_POSITIVO:	
		ret				# retorna em a0 o valor obtido
############################################################################
