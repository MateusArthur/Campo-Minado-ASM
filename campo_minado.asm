# ALUNO: MATEUS ARTHUR MARCHIORI ROCHA

	.data
nivel:			.asciz		"\nDigite o nivel entre: 8/10/12 (Tamanho do tabuleiro): "
nivelInvalido:    	.asciz		"\nNivel invalido, escolha um nivel valid0! [8/10/12]"
mostrarCampo:       	.asciz		"\nSeu campo minado:\n"
espaco:             	.asciz     	" "
hifen: 			.asciz		"-"
bomba:              	.asciz     	" 9"
novalinha:	    	.asciz		"\n"
novabarra:	    	.asciz		"|"

campo:                          # Matriz controle campo minado 
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0
        .word   0,0,0,0,0,0,0,0,0,0,0,0

matrizUsuario:                  # matriz interface
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
        
        addi a3, zero, 8           # adicione 8 no a3 para verificar dps
        beq a1, a3, else           # verifica se dificuldade e 8
        addi a3, zero, 10          # adicione 10 no a3 para verificar dps
        beq a1, a3, else           # verifica se dificuldade e 10
        addi a3, zero, 12	   # adicione 12 no a3 para verificar dps
        beq a1, a3, else           # verifica se dificuldade e 12
        li  t0, 4                  # define operacao de chamada
        la  a0, nivelInvalido      # imprime nivel invalido
        li a7, 4		   # preapara para imprimir uma string
        ecall                      # imprime a string
        j main                     # volta para main pois tamanho e invalido

else:                       	  # se nivel valido
        add a3, zero, zero        # seta a3 como controle de fim do jogo
        la a0, campo              # referencia da matriz campo 
        la a2, matrizUsuario      # referencia da matriz usuario
        jal mostra_campo      	  # printa campo minado
        
print_hifen:
	la a0, hifen              # carrega string
        li a7, 4		  # preparar para imprimir uma string
        ecall		          # imprime a string
	j for2
        
        
mostra_campo:
	add s4, a0, zero          # salva endereco da matriz campo
        li  t0, 4                 # define operacao de chamada
        
        la  a0, mostrarCampo      # imprime mensagem para mostrar campo minado
        li a7, 4		  # preparar para imprimir uma string
        ecall		          # imprime a string
        
        add t2, zero, zero        # reseta variavel linhas

for:
        addi t3, zero, -1         # reseta variavel colunas
        beq t2, a1, exit          # verifica fim do for

for2:
        addi t3, t3, 1            # aumenta contador de colunas
        beq t3, a1, exit1         # verifica fim do for2
	
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
        bne a3, a6, if20   
        
        addi a6, zero, 12     
        bne t5, a6, if20            # verifica se a posicao da matriz campo[x1][y1] == 12

        li t0, 4                   # define operacao de chamada
        la a0, bomba               # imprime valor 9 (bomba)
        li a7, 4		   # preparar para imprimir uma string
        ecall		           # imprime a string
        j for2                     # volta para for2 porque o valor e bomba

if20:
        addi a6, zero, -1      
        beq s3, a6, if21           # verifica necessidade de imprimir um espaco
        
        # imprime um espaco
        li t0, 4                   # define operacao de chamada
        la a0, espaco              # carrega string
        li a7, 4		   # preparar para imprimir uma string
        ecall			   # imprime uma string

if21:
         # imprime as posicoes
        li t0, 1                   # seta valor de operacao
        add a0, s3, zero           # salva valor de s3 em a0 para ser impresso
        addi a6, zero, -1          # adicionar -1 em a6 para verificar dps
        beq a0, a6, print_hifen    # verifica se imprime o hifen
        li a7, 1		   # preparar para imprimir um inteiro
        ecall	

        j for2                      # volta para for2
        
exit1:
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
        j for                      # volta para for
 
exit:
	nop
           	