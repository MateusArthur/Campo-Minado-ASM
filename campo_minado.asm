# ALUNO: MATEUS ARTHUR MARCHIORI ROCHA

	.data
nivel:			.asciz		"\nEscolha um nivel:\n1 - 5x5\n2 - 7x7\n3 - 9x9\nDigite qual deseja: "
nivelInvalido:    	.asciz		"\nNivel invalido, escolha um nivel valido: (1) - 5x5 ou (2) - 7x7 ou (3) - 9x9!"
mostrarCampo:       	.asciz		"\nSeu campo minado:\n"
espaco:             	.asciz     	" "
hifen: 			.asciz		"-"
bomba:              	.asciz     	" 9"
novalinha:	    	.asciz		"\n"
novabarra:	    	.asciz		"|"

campo:                          # Matriz controle campo minado 
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0

interface:                  # matriz interface
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        .word   -1,-1,-1,-1,-1,-1,-1,-1,-1
        
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
        beq a1, a3, tamanho5x5     # verifica se dificuldade e 5
        addi a3, zero, 2           # 
        beq a1, a3, tamanho7x7     # verifica se dificuldade e 7
        addi a3, zero, 3	   # 
        beq a1, a3, tamanho9x9     # verifica se dificuldade e 10
        
        li  t0, 4                  # define operacao de chamada
        la  a0, nivelInvalido      # imprime nivel invalido
        li a7, 4		   # preapara para imprimir uma string
        ecall                      # imprime a string
        j main                     # volta para main pois tamanho e invalido

tamanho5x5:
	addi a1, zero, 5	   # carregar campos de acordo com nivel escolhido
	j else

tamanho7x7:
	addi a1, zero, 7	  # carregar campos de acordo com nivel escolhido
	j else
	
tamanho9x9:
	addi a1, zero, 9	  # carregar campos de acordo com nivel escolhido
	
else:                       	  # se nivel valido
        add a3, zero, zero        # seta a3 como controle de fim do jogo
        la a0, campo              # referencia da matriz campo 
        la a2, interface          # referencia da matriz interface
        jal mostra_campo      	  # printa campo minado
        
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
        add a0, zero, s10          # coloca em a0 o id da coluna atual
        li a7, 1		   # preparar para imprimir um int
        ecall		           # imprime um int
        
        addi s10, s10, 1	   # soma +1 na coluna
        
        j print_colunas		   # comeca de novo

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
        jal print_colunas
        
back:
	# imprime nova linha
        li t0, 4                   # seta valor de operação para string
        la a0, novalinha           # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        
        add t2, zero, zero        # reseta variavel linhas
        
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
	
	addi a6, zero, 9
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
        
        addi a6, zero, 9     
        bne t5, a6, imprime_espaco            # verifica se a posicao da matriz campo[x1][y1] == 9

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
        
        add a0, zero, t2           # carrega um inteiro
        li a7, 1		   # preparar para imprimir um inteiro
        ecall		           # imprime o inteiro
        
        j for_linha                # volta para for_linha
 
fim:
	nop
           	