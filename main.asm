%macro puts 1
    mov rdi, %1
    sub rsp, 8
    call puts
    add rsp, 8
%endmacro

%macro print 2
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call printf
    add rsp, 8
%endmacro

extern puts

section .data

    ; Tableros y sus posibles estados

    tableroOrig         db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","X","X","X","|"," "," ",10
                        db "2"," ","_","|","X","X","X","|","_"," ",10
                        db "3","|","X","X","X","X","X","X","X","|",10 
                        db "4","|","X","X","X","X","X","X","X","|",10 
                        db "5","|","X","X"," "," "," ","X","X","|",10 
                        db "6"," ","¯","|","O"," ","O","|","¯"," ",10 
                        db "7"," "," ","|"," "," "," ","|"," "," ",10 
                        db " "," "," "," ","¯","¯","¯"," "," "," ",10,0

    tableroInv          db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|"," "," "," ","|"," "," ",10
                        db "2"," ","_","|","O"," ","O","|","_"," ",10
                        db "3","|","X","X"," "," "," ","X","X","|",10 
                        db "4","|","X","X","X","X","X","X","X","|",10 
                        db "5","|","X","X","X","X","X","X","X","|",10 
                        db "6"," ","¯","|","X","X","X","|","¯"," ",10 
                        db "7"," "," ","|","X","X","X","|"," "," ",10 
                        db " "," "," "," ","¯","¯","¯"," "," "," ",10,0

    tableroIzq          db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","X","X","X","|"," "," ",10
                        db "2"," ","_","|","X","X","X","|","_"," ",10
                        db "3","|","X","X","X","X"," ","O"," ","|",10 
                        db "4","|","X","X","X","X"," "," "," ","|",10 
                        db "5","|","X","X","X","X"," ","O"," ","|",10 
                        db "6"," ","¯","|","X","X","X","|","¯"," ",10 
                        db "7"," "," ","|","X","X","X","|"," "," ",10 
                        db " "," "," "," ","¯","¯","¯"," "," "," ",10,0

    tableroDer          db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","X","X","X","|"," "," ",10
                        db "2"," ","_","|","X","X","X","|","_"," ",10
                        db "3","|"," ","O"," ","X","X","X","X","|",10 
                        db "4","|"," "," "," ","X","X","X","X","|",10 
                        db "5","|"," ","O"," ","X","X","X","X","|",10 
                        db "6"," ","¯","|","X","X","X","|","¯"," ",10 
                        db "7"," "," ","|","X","X","X","|"," "," ",10 
                        db " "," "," "," ","¯","¯","¯"," "," "," ",10,0

    ; Mensajes

    msgBienvenida       db "¡Bienvenido al juego El Asalto!", 0

    msgPersonalizarTablero  db "¿Desea personalizar el tablero? (s/n): ", 0 
    
    msgPregRotacion         db "¡Se puede rotar el tablero! Elija una de las opciones (1-4):", 0
    msgRotacionesPosibles   db "1. Rotar a la izquierda", 0
                            db "2. Rotar a la derecha", 0
                            db "3. Invertir el tablero", 0
                            db "4. No rotar", 0
    
    msgPersonalizarSimb     db "¡Elijamos los símbolos para cada personaje!", 0
    msgSimboloOficiales     db "Símbolo para los oficiales:", 0
    msgSimboloSoldados      db "Símbolo para los soldados:", 0

    msgQuienInicia          db "¿Quién inicia el juego: oficiales o soldados? (o/s): ", 0

    msgOficialRetirado      db "¡Un oficial ha sido retirado del juego! Se ha olvidado de atrapar a un soldado.", 0

    msgOficial1             db "Oficial 1:", 0
    msgOficial2             db "Oficial 2:", 0

    msgCantMovimientos      db "Movimientos totales: %d", 0
    msgCantAdelante         db "- Hacia adelante: %d", 0
    msgCantDerecha          db "- Hacia la derecha: %d", 0
    msgCantIzquierda        db "- Hacia la izquierda: %d", 0
    msgCantAtras            db "- Hacia atrás: %d", 0
    msgCantDiagonal         db "- En diagonal: %d", 0

    msgJuegoTerminado       db "¡El juego ha terminado!", 0
    msgGanador              db "¡El ganador es el equipo de los %s!", 0
    msgRazonGanador         db "Razón: %s", 0

    msgSoldadosFortaleza    db "los soldados han ocupado todos los puntos de la fortaleza.", 0
    msgSoldadosRodean       db "los soldados han rodeado a los oficiales.", 0
    msgOficialesGanan       db "no quedan suficientes soldados para ocupar la fortaleza.", 0

section .text
    global main

main:
    puts tableroOrig
    puts tableroInv
    puts tableroIzq
    puts tableroDer

    ret

        
