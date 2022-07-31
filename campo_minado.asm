# DUPLA: Édipo Antônio de Jesus e Mateus Arthur Marchiori Rocha

		.data

interface:                  # matriz interface
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        
campo:			.space		576
nivel:			.asciz		"\nEscolha um nivel:\n1 - 8x8\n2 - 10x10\n3 - 12x12\nDigite qual deseja: "
nivelInvalido:    	.asciz		"\nNivel invalido, escolha um nivel valido: (1) - 8x8 ou (2) - 10x10 ou (3) - 12x12!"
mostrarCampo:       	.asciz		"\nSeu campo minado:\n"
opcoes:			.asciz		"\n1 - Abrir Posicao\n2 - Inserir Bandeira\n3 - Retirar Bandeira\n4 - Mostrar Campo"
espaco:             	.asciz     	" "
hifen: 			.asciz		"-"
bomba:              	.asciz     	" 9"
novalinha:	    	.asciz		"\n"
novabarra:	    	.asciz		"|"
salva_S0:		.word		0
salva_ra:		.word		0
salva_ra1:		.word		0
        
	.text
	
main:
	li  t0, 4                  # define operacao de chamada
        la  a0, nivel        	   # imprime a escolha do nivel
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string

        li  t0, 5		   # prepara pra pegar valor digitado
        li a7, 5		   # prepara para ler um inteiro
        ecall                      # Imprime para usuario digitar tamanhao campo
        add a1, zero, a0	   # Adiciona valor inserido pelo usuario em a1
        
        addi a3, zero, 1           #
        beq a1, a3, tamanho8x8     # verifica se dificuldade e 8
        addi a3, zero, 2           # 
        beq a1, a3, tamanho10x10   # verifica se dificuldade e 10
        addi a3, zero, 3	   # 
        beq a1, a3, tamanho12x12   # verifica se dificuldade e 12
        
        li  t0, 4                  # define operacao de chamada
        la  a0, nivelInvalido      # imprime nivel invalido
        li a7, 4		   # preapara para imprimir uma string
        ecall                      # imprime a string
        j main                     # volta para main pois tamanho e invalido

tamanho8x8:
	addi a1, zero, 8	   # carregar campos de acordo com nivel escolhido
	j else

tamanho10x10:
	addi a1, zero, 10	  # carregar campos de acordo com nivel escolhido
	j else
	
tamanho12x12:
	addi a1, zero, 12	  # carregar campos de acordo com nivel escolhido
	
else:                       	  # se nivel valido
	la a0, campo              # referencia da matriz campo 
        la a2, interface          # referencia da matriz interface
        add s5, zero, a1	  # armazenar o valor de a1 pq vai ser mudado na funcao INSERE_BOMBAS
        add a3, zero, zero        # seta a3 como controle de fim do jogo
        add a1, a1, zero	  # parâmetro do tamanho da matriz campo
	jal INSERE_BOMBA	  # chama função para inserir as bombas na matriz campo
	add a1, zero, s5

main_loop: # loop do jogo
	la a0, campo              # referencia da matriz campo 
        la a2, interface          # referencia da matriz interface
        
	jal mostra_campo      	  # printa campo minado
	
	li  t0, 4                  # define operacao de chamada
        la  a0, opcoes        	   # imprime a escolha do nivel
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        
	j main_loop
	
print_hifen:
	la a0, hifen              # carrega string
        li a7, 4		  # preparar para imprimir uma string
        ecall		          # imprime a string
	j for_coluna
        
print_colunas:
	li t0, 4                   # seta valor de operacao para string
        la a0, espaco              # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        
        bge s10, a1, back	   # Verifica se ja imprimiu a ultima coluna e volta para aonde foi chamado
        
        # verificar se precisa tabular
        addi a6, zero, 9
       	addi a7, zero, 1
       	bgt s10, a6, tabulador
       	add a6, zero, s10
       	
continua_coluna:
        add a0, zero, a6          # coloca em a0 o id da coluna atual
        li a7, 1		   # preparar para imprimir um int
        ecall		           # imprime um int
        
        addi s10, s10, 1	   # soma +1 na coluna
       
        j print_colunas		   # comeca de novo

# void mostra_campo(int * campo[], int size_table, int * interface[], int controle)
mostra_campo:
	add s4, a0, zero           # salva endereco da matriz campo
        li  t0, 4                  # define operacao de chamada
        
        la  a0, mostrarCampo       # imprime mensagem para mostrar campo minado
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        
        li t0, 4                   # seta valor de operacao para string
        la a0, espaco              # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        
        add s10, zero, zero	   # carregar s10
        j print_colunas
        
back:
	# imprime nova linha
        li t0, 4                   # seta valor de operação para string
        la a0, novalinha           # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        
        add t2, zero, zero        # reseta variavel linhas
        
        addi a6, zero 9
        add a0, zero, t2           # carrega um inteiro
        li a7, 1		   # preparar para imprimir uma string
        ecall		           # imprime a string

for_linha:
	# t3 colunas e t2 linhas [ LEMBRAR ]
        addi t3, zero, -1         # reseta variavel colunas
        beq t2, a1, fim           # verifica se ja percorreu toda a matriz

for_coluna:
        addi t3, t3, 1            # aumenta contador de colunas
        beq t3, a1, fim_coluna    # verifica se ja imprimiu a ultima coluna
	
	addi a6, zero, 12
        mul s1, t2, a6            # posicao_matriz = y (linhas) * ordem da matriz (12)
        add s1, s1, t3            # posicao_matriz += x (colunas)
        
        addi a6, zero, 4
        mul s1, s1, a6            # calculo a posicao
        add s3, s1, a2            # calcula endereco da posicao da matriz usuario
        lw  s3, 0(s3)             # salva posicao da matriz usuario
        add t5, s1, s4            # calcula endereco da matriz campo
        lw  t5, 0(t5)             # salva posicao da matriz campo
        
        # imprime uma barra
        li t0, 4              	  # seta valor de operação para string
        la a0, espaco             # carrega string
        li a7, 4		  # preparar para imprimir uma string
        ecall		          # imprime a string
        
        # verifica variavel de fim de jogo, caso nao termine entao continua
        addi a6, zero, 1
        bne a3, a6, imprime_espaco   
        
        addi a6, zero, 12     
        bne t5, a6, imprime_espaco            # verifica se a posicao da matriz campo[x1][y1] == 12

        li t0, 4                   # define operacao de chamada
        la a0, bomba               # imprime valor 9 (bomba)
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        j for_coluna               # volta para for_coluna porque o valor e bomba

imprime_espaco :
        addi a6, zero, -1      
        beq s3, a6, imprime_casa   # verifica necessidade de imprimir um espaco
        
        # imprime um espaco
        li t0, 4                   # define operacao de chamada
        la a0, espaco              # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall			   # imprime uma string

imprime_casa:
        # imprime as posicoes
        li t0, 1                   # seta valor de operacao
        add a0, s3, zero           # salva valor de s3 em a0 para ser impresso
        addi a6, zero, -1          # adicionar -1 em a6 para verificar dps
        beq a0, a6, print_hifen    # verifica se imprime o hifen
        li a7, 1		   # preparar para imprimir um inteiro
        ecall	

        j for_coluna               # volta para for_coluna
        
fim_coluna:
        # imprime uma barra
        li t0, 4                   # seta valor de operacao para string
        la a0, espaco              # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        
        # imprime nova linha
        li t0, 4                   # seta valor de operação para string
        la a0, novalinha           # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        
        addi t2, t2, 1             # aumenta contador de linha
        
        # como comeca em zero nao precisa imprimir o ultimo numero ( 5, 7, 9) ...
        bge t2, a1, for_linha	   # verifica se t2 (contador de linha) e maior ou igual a1 (numero total de linhas) se for imprime o numero da linha
        
        # Imprime id linha
        addi a6, zero, 9
       	bgt t2, a6, tabuladorl
       	add a6, zero, t2
       	
continua_linha:
        add a0, zero, a6           # carrega um inteiro
        li a7, 1		   # preparar para imprimir um inteiro
        ecall		           # imprime o inteiro
        
        j for_linha                # volta para for_linha
 
tabulador:
	addi a6, s10, -10
	j continua_coluna
	
tabuladorl:
	addi a6, t2, -10
	j continua_linha
 
fim:
	ret
	
INSERE_BOMBA:
		la	t0, salva_S0
		sw  	s0, 0 (t0)		# salva conteudo de s0 na memoria
		la	t0, salva_ra
		sw  	ra, 0 (t0)		# salva conteudo de ra na memoria
		
		add 	t0, zero, a0		# salva a0 em t0 - endereço da matriz campo
		add 	t1, zero, a1		# salva a1 em t1 - quantidade de linhas 

QTD_BOMBAS:
		addi 	t2, zero, 15 		# seta para 15 bombas	
		add 	t3, zero, zero 	# inicia contador de bombas com 0
		addi 	a7, zero, 30 		# ecall 30 pega o tempo do sistema em milisegundos (usado como semente
		ecall 				
		add 	a1, zero, a0		# coloca a semente em a1
INICIO_LACO:
		beq 	t2, t3, FIM_LACO
		add 	a0, zero, t1 		# carrega limite para %	(resto da divisão)
		jal 	PSEUDO_RAND
		add 	t4, zero, a0		# pega linha sorteada e coloca em t4
		add 	a0, zero, t1 		# carrega limite para % (resto da divisão)
   		jal 	PSEUDO_RAND
		add 	t5, zero, a0		# pega coluna sorteada e coloca em t5
		
LE_POSICAO:	
		mul  	t4, t4, t1
		add  	t4, t4, t5  		# calcula (L * tam) + C
		add  	t4, t4, t4  		# multiplica por 2
		add  	t4, t4, t4  		# multiplica por 4
		add  	t4, t4, t0  		# calcula Base + deslocamento
		lw   	t5, 0(t4)   		# Le posicao de memoria LxC
VERIFICA_BOMBA:		
		addi 	t6, zero, 9		# se posição sorteada já possui bomba
		beq  	t5, t6, PULA_ATRIB	# pula atribuição 
		sw   	t6, 0(t4)		# senão coloca 9 (bomba) na posição
		addi 	t3, t3, 1		# incrementa quantidade de bombas sorteadas
PULA_ATRIB:
		j	INICIO_LACO

FIM_LACO:					# recupera registradores salvos
		la	t0, salva_S0
		lw  	s0, 0(t0)		# recupera conteudo de s0 da memória
		la	t0, salva_ra
		lw  	ra, 0(t0)		# recupera conteudo de ra da memória		
		jr 	ra			# retorna para funcao que fez a chamada
		
PSEUDO_RAND:
		addi t6, zero, 125  		# carrega constante t6 = 125
		lui  t5, 682			# carrega constante t5 = 2796203
		addi t5, t5, 1697 		# 
		addi t5, t5, 1034 		# 	
		mul  a1, a1, t6			# a = a * 125
		rem  a1, a1, t5			# a = a % 2796203
		rem  a0, a1, a0			# a % lim
		bge  a0, zero, EH_POSITIVO  	# testa se valor eh positivo
		addi s2, zero, -1           	# caso não 
		mul  a0, a0, s2		    	# transforma em positivo
EH_POSITIVO:	
		ret				# retorna em a0 o valor obtido
