# DUPLA: Mateus Arthur Marchiori Rocha

		.data
interface:		.space          576
campo:			.space		576
nivel:			.asciz		"\nEscolha um nivel:\n1 - 8x8\n2 - 10x10\n3 - 12x12\nDigite qual deseja: "
nivelInvalido:    	.asciz		"\nNivel invalido, escolha um nivel valido: (1) - 8x8 ou (2) - 10x10 ou (3) - 12x12!"
mostrarCampo:       	.asciz		"\nSeu campo minado:\n"
m_opcoes:		.asciz		"\nMenu de Opcoes:\n"
opcoes:			.asciz		"\n1 - Abrir Posicao\n2 - Inserir/Retirar Bandeira\nOutro - Mostrar campo\n"
digitar_linha:		.asciz		"\nDigite o numero da linha em que deseja inserir: "
digitar_coluna:		.asciz		"\nDigite o numero da coluna em que deseja inserir: "
erro_aberto:		.asciz		"\nERRO! Esta casa ja foi aberta!\n"
erro_digito:		.asciz		"\nERRO! Posicao invalida!\n"
erro_flag:		.asciz		"\nERRO! Nao foi possivel adicionar a flag posicao ja aberta!\n"
erro_cflag:		.asciz		"\nERRO! Nao pode abrir valor com flag!\n"
aviso_perdeu:		.asciz		"\nVOCE PERDEU!\n GAME OVER!!!\n"
espaco:             	.asciz     	" "
hifen: 			.asciz		"-"
bomba:              	.asciz     	" 9"
flag:			.asciz		"F"
novalinha:	    	.asciz		"\n"
novabarra:	    	.asciz		"|"
salva_S0:		.word		0
salva_ra:		.word		0
salva_ra1:		.word		0
        
	.text
	
main:
	jal resetar_matrizes	   # resetar e inicializar as matrizes	
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
	
	la a0, campo		  # referencia a matriz campo
	add a1, s5, zero	  # numero de linhas em a1
	jal calcula_bombas

	
	add a1, zero, s5

main_loop: # loop do jogo
	la a0, campo               # referencia da matriz campo 
        la a2, interface           # referencia da matriz interface
        
	jal mostra_campo      	   # printa campo minado
	
	bgtz a3, case_perdeu	   # Verifica se perdeu para mostrar a mensagem que perdeu
	add  s4, a0, zero          # salva endereco da matriz campo
	
	addi s7, zero, 2
        beq s6,	s7, case_flag  	   # Inserir/Remover uma Flag
	
	li  t0, 4                  # define operacao de chamada
        la  a0, m_opcoes       	   # imprime a escolha do nivel
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        
	li  t0, 4                  # define operacao de chamada
        la  a0, opcoes        	   # imprime a escolha do nivel
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        
        li  t0, 5		   # prepara pra pegar valor digitado
        li a7, 5		   # prepara para ler um inteiro
        ecall                      # Imprime para usuario digitar tamanhao campo
        add s6, zero, a0	   # Adiciona valor inserido pelo usuario em s6
        
        # Verificar opcoes
        addi s7, zero, 1
        beq s6,	s7, abrir_posicao  # Abrir uma Posicao
        
	j main_loop
	
abrir_posicao:	
	li  t0, 4                  # define operacao de chamada
        la  a0, digitar_linha     # carrega string que desejamos imprimir
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        
        li  t0, 5		   # prepara pra pegar valor digitado
        li a7, 5		   # prepara para ler um inteiro
        ecall                      # Imprime para usuario digitar tamanhao campo
        add s6, zero, a0	   # Adiciona valor inserido pelo usuario em s6
        bge s6, a1, valor_invalido # se coluna  maior ou igual q valor maximo de coluna entao erro
        
        li  t0, 4                  # define operacao de chamada
        la  a0, digitar_coluna     # carrega string que desejamos imprimir
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        
        li  t0, 5		   # prepara pra pegar valor digitado
        li a7, 5		   # prepara para ler um inteiro
        ecall                      # Imprime para usuario digitar tamanhao campo
        add s7, zero, a0	   # Adiciona valor inserido pelo usuario em s7
        bge s7, a1, valor_invalido # se linha maior ou igual q valor maximo de linhas entao erro
        
        #(linha * numero de colunas) + coluna
        addi s5, zero, 12
        mul s1, s6, s5         	   # pos = linha * 12
        add s1, s1, s7         	   # pos += coluna
        addi a5, zero, 4	   # auxiliar de bits
        mul s1, s1, a5             # posição_matriz *= 4 (para calcular posição)
        
        la a0, campo 		   # carrega o campo
        add a5, a0, s1 		   # pega a posicao do indice que queremos

        lw  s3, (a5) 		   # salva endereço da posição campo
        
        # Verificar se existe uma flag
	addi a6, zero, -1 	   # -1 e o numero da q indentifica a flag
	blt s3, a6, com_flag       # verifica se e uma flag
        
        la a2, interface            # carrega a matriz interface
        add a5, a2, s1              # pega o index da posicao
        sw  s3, (a5)                # salva valor encontrado na matiz campo na matriz usuario
        
        addi s7, zero, 9 	
        beq s3, s7, game_over 	   # Verifica se e bomba para mudar o game over
        addi s6, zero, 0	   # resetar variavel para voltar para main certo
        j mostra_campo

com_flag:
	li  t0, 4                  # define operacao de chamada
        la  a0, erro_cflag         # carrega string que desejamos imprimir
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
	ret
	
case_flag:
	li  t0, 4                  # define operacao de chamada
        la  a0, digitar_linha      # carrega string que desejamos imprimir
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        
        li  t0, 5		   # prepara pra pegar valor digitado
        li a7, 5		   # prepara para ler um inteiro
        ecall                      # Imprime para usuario digitar tamanhao campo
        add s6, zero, a0	   # Adiciona valor inserido pelo usuario em s6
        bgt s6, a1, valor_invalido # se coluna maior q valor maximo de coluna entao erro
        
        li  t0, 4                  # define operacao de chamada
        la  a0, digitar_coluna     # carrega string que desejamos imprimir
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        
        li  t0, 5		   # prepara pra pegar valor digitado
        li a7, 5		   # prepara para ler um inteiro
        ecall                      # Imprime para usuario digitar tamanhao campo
        add s7, zero, a0	   # Adiciona valor inserido pelo usuario em s7
        bgt s7, a1, valor_invalido # se linha maior q valor maximo de linhas entao erro
        
        #(linha * numero de colunas) + coluna
        addi s5, zero, 12
        mul s1, s6, s5         	   # pos = linha * 12
        add s1, s1, s7             # pos += coluna
        addi a5, zero, 4
        mul s1, s1, a5         # posição_matriz *= 4 (para calcular posição)
        
        la a0, campo
        add a5, a0, s1

        lw  s3, (a5)     	# salva endereço da posição campo
        
	# Verificar se a flag ja existe para remover
	addi a6, zero, -1
	blt s3, a6, remove_flag
	
	la a2, interface
        add a5, a2, s1
        lw  s3, (a5)
        
        bgez s3, bo_flag #verifica se a posição já foi aberta
        
	# manipular flag
	
	la a0, campo
        add a5, a0, s1

        lw  s3, (a5) 
	
	addi s3, s3, -13 	#adiciona bandeira (diminui 13 no valor presente na posição)
	addi s9, s9, -1		#dimunui o numero de bandeiras disponiveis
	
	sw s3, (a5)		#salva novo valor na matriz campo
	
	la a2, interface
        add a5, a2, s1
        sw  s3, (a5)		#salva o valor na matriz usuario
	
	# Se nao existir coloca a flag
        addi s6, zero, 0	   # resetar variavel para voltar para main certo
        j mostra_campo
        
remove_flag:
        la a2, interface
        add a5, a2, s1
        lw  s3, (a5)
 	
 	# manipular flag
	la a0, campo
        add a5, a0, s1

        lw  s3, (a5) 
	addi s3, s3, 13 	#adiciona bandeira (soma 13 no valor presente na posição)
	sw s3, (a5)		#salva novo valor na matriz campo
	
	la a2, interface
        add a5, a2, s1
        addi s3, zero, -1	# seta -1 matriz usuario para voltar o hifen
        sw  s3, (a5)		# salva o valor na matriz usuario
        
        addi s6, zero, 0	   # resetar variavel para voltar para main certo
        j mostra_campo

bo_flag:
	li  t0, 4                  # define operacao de chamada
        la  a0, erro_flag          # carrega string que desejamos imprimir
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
	j mostra_campo
	
valor_invalido:
	li  t0, 4                  # define operacao de chamada
        la  a0, erro_digito        # carrega string que desejamos imprimir
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        ret
	
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

imprime_espaco:
        addi a6, zero, -1      
        beq s3, a6, imprime_casa   # verifica necessidade de imprimir um hifen
        bgez s3, imprime_valor 	   # verifica a necessidade de imprimir um valor
        blt s3, a6, imprime_flag
        
        # imprime um espaco
        li t0, 4                   # define operacao de chamada
        la a0, espaco              # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall			   # imprime uma string

imprime_casa:
        # imprime as posicoes
        add a0, s3, zero           # salva valor de s3 em a0 para ser impresso
        addi a6, zero, -1          # adicionar -1 em a6 para verificar dps
        beq a0, a6, print_hifen    # verifica se imprime o hifen

        j for_coluna               # volta para for_coluna
       
imprime_valor:
	# Lembrar de verificar uma flag
	add a0, zero, s3           # carrega um inteiro
        li a7, 1		   # preparar para imprimir um inteiro
        ecall		           # imprime o inteiro
        
        j for_coluna

imprime_flag:
	li t0, 4                   # define operacao de chamada
        la a0, flag                # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall			   # imprime uma string
        
        j for_coluna
        
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
        
        # como comeca em zero nao precisa imprimir o ultimo numero ( 8, 10, 12) ...
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

calcula_bombas:                     
        addi s2, a1, -1             # num_linhas - 1 (12-1)
        addi t4, zero, 12	    # auxiliar para calcular
        addi t5, zero, 4	    # auxiliar de bits
        addi a6, zero, 9	    # auxiliar para calcular
        add t2, zero, zero          # reseta variavel linhas

for_lin_calcb:
        addi t3, zero, -1           # reseta variavel colunas
        beq t2, a1, fim             # percorreu todas as linhas e colunas

for_col_calcb:
        add s0, zero, zero          # resetar o contador de bombas
        addi t3, t3, 1              # aumenta contador de colunas (colunas++)
        beq t3, a1, fim2            # verifica fim do laco

        mul s1, t2, t4              # posicao_matriz = linhas * 12
        add s1, s1, t3              # posicao_matriz + colunas
        mul s1, s1, t5              # calculo da posicao

        add s3, s1, a0              # calcula endereco da matriz campo
        lw  s3, 0(s3)               # salva posicao da matriz

        
        bne s3, a6, if1     	    # verifica se e bomba
        j for_col_calcb             # volta para for (valor e bomba so deve mostrar o 9)

#	Y X X
#	X P X
#	X X X
if1:
        addi s3, s1, -4            # posicao_matriz - 4 ([x-1][y])
        addi s3, s3, -48           # posicao_matriz - 48 ([x-1][y-1])   
        add s3, a0, s3             # calcula enderecoo da matriz
        lw  s3, 0(s3)              # salva posicao da matriz
        beqz t2, if2               # verifica y != 0
        beqz t3, if2               # verifica x != 0
        bne s3, a6, if2            # verifica se e bomba
        addi s0, s0, 1             # i++

#	X Y X
#	X P X
#	X X X
if2:
        addi s3, s1, -48          # posicao_matriz - 48 ([x][y-1])   
        add s3, s3, a0            # calcula endereco da matriz
        lw  s3, 0(s3)             # salva posicao da matriz
        beqz t2, if3              # verifica y != 0
        bne s3, a6, if3           # verifica se e bomba
        addi s0, s0, 1            # i++

#	X X Y
#	X P X
#	X X X
if3:
        addi s3, s1, 4            # posicao_matriz + 4 ([x+1][y])
        addi s3, s3, -48          # posicao_matriz - 48 (M[x+1][y-1])
        add s3, s3, a0            # calcula endereco da matriz
        lw  s3, 0(s3)             # salva posicao da matriz
        
        beq t3, s2, if4           # verifica x != num_linhas
        beqz t2, if4              # verifica y != 0
        bne s3, a6, if4           # verifica se e bomba
        addi s0, s0, 1            # i++

#	X X X
#	Y P X
#	X X X

if4:
        addi s3, s1, -4           # posicao_matriz - 4 ([x-1][y]) 
        add s3, s3, a0            # calcula endereco da matriz
        lw  s3, 0(s3)             # salva posicao da matriz
        
        beqz t3, if5              # verifica x != 0
        bne s3, a6, if5           # verifica se e bomba
        addi s0, s0, 1            # i++

#	X X X
#	X P Y
#	X X X

if5:
        addi s3, s1, 4            # posicao_matriz + 4 ([x+1][y]) 
        add s3, s3, a0            # calcula endereco da matriz
        lw  s3, 0(s3)             # salva posicao da matriz
        
        beq t3, s2, if6           # verifica x != num_linhas
        bne s3, a6, if6           # verifica se e bomba
        addi s0, s0, 1            # i++


#	X X X
#	X P X
#	Y X X
if6:
        addi s3, s1, -4           # posicao_matriz - 4 ([x-1][y])
        addi s3, s3, 48           # posicao_matriz + 48 ([x-1][y+1])
        add s3, s3, a0            # calcula endereco da matriz
        lw  s3, 0(s3)             # salva posicao da matriz

        beqz t3, if7              # verifica x != 0
        beq t2, s2, if7           # verifica y != num_linhas
        bne s3, a6, if7           # verifica se e bomba
        addi s0, s0, 1            # i++


#	X X X
#	X P X
#	X Y X
if7:
        addi s3, s1, 48           # posicao_matriz + 48 ([x][y+1])
        add s3, s3, a0            # calcula endereco da matriz
        lw  s3, 0(s3)             # salva posicao da matriz
        
        beq t2, s2, if8           # verifica y != num_linhas
        bne s3, a6, if8           # verifica se e bomba
        addi s0, s0, 1            # i++

#	X X X
#	X P X
#	X X Y
if8:
        addi s3, s1, 4            # posicao_matriz + 4 ([x+1][y])
        addi s3, s3, 48           # posicao_matriz + 48 ([x+1][y+1])
        add s3, s3, a0            # calcula endereco da matriz
        lw  s3, 0(s3)             # salva posicao da matriz

        beq t3, s2, continuar_calc     # verifica se x != num_linhas
        beq t2, s2, continuar_calc     # verifica se y != num_linhas
        bne s3, a6, continuar_calc     # verifica se e bomba
        addi s0, s0, 1            # i++

continuar_calc:
        add s3, s1, a0           # calcula endereco da matriz                   
        sw  s0, 0(s3)            # seta o valor de bombas ao redor da posicao
        j for_col_calcb          # volta para o for de colunas

fim2:
        addi t2, t2, 1            # aumenta contador de linhas da matriz
        j for_lin_calcb           # volta para o for de linhas
        
game_over:
	addi a3, zero, 1
	j mostra_campo
	
case_perdeu:
	li  t0, 4                  # define operacao de chamada
        la  a0, aviso_perdeu       # imprime a escolha do nivel
        li a7, 4		   # prepara para imprimir uma string
        ecall                      # imprime a string
        
        j main

resetar_matrizes:
	la a0, campo
	la a1, interface
	
	addi a2, zero, 4 # Auxiliar de bits
	addi a3, zero, 12 # Numero de casas
	addi s0, zero, 0 # contador de linhas
	
	addi t0, zero, 0
	addi t1, zero, -1
	
for_res_lin:
	add s1, zero, zero # resetar contador de colunas
	
for_res_col:

	sw t0, 0(a0)		# Inserir 0 no campo
	sw t1, 0(a1)		# Inserir -1 na interface
	
	add a0, a0, a2		# proxima posicao do vetor campo
	add a1, a1, a2		# proxima posicao do vetor interface
	
	addi s1, s1, 1		# coluna++
	
	blt s1, a3, for_res_col # se coluna for menor que 12 volta para o loop
	
	
	addi s0, s0, 1		# linha ++
	blt s0, a3, for_res_lin # enquanto s0 (contador de linhas) for menor que 12 volta para o for_res_lin
	# se passar aqui terminou a matriz
	       
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
