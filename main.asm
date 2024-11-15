%macro mPuts 1
    mov rdi, %1
    sub rsp, 8
    call puts
    add rsp, 8
%endmacro

%macro mPrint 2
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call printf
    add rsp, 8
%endmacro

%macro mGets 1
    mov rdi, %1
    sub rsp, 8
    call gets
    add rsp, 8
%endmacro

extern puts, printf
extern gets

section .data

    ; Tableros y sus posibles estados

    tableroOrig         db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","X","X","X","|"," "," ",10
                        db "2"," ","_","|","X","X","X","|","_"," ",10
                        db "3","|","X","X","X","X","X","X","X","|",10 
                        db "4","|","X","X","X","X","X","X","X","|",10 
                        db "5","|","X","X"," "," "," ","X","X","|",10 
                        db "6"," ","¯","|","O"," "," ","|","¯"," ",10 
                        db "7"," "," ","|"," "," ","O","|"," "," ",10 
                        db " "," "," "," ","¯","¯","¯"," "," "," ",10,0

    tableroInv          db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","O"," "," ","|"," "," ",10
                        db "2"," ","_","|"," "," ","O","|","_"," ",10
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
                        db "3","|","X","X","X","X"," "," ","O","|",10 
                        db "4","|","X","X","X","X"," "," "," ","|",10 
                        db "5","|","X","X","X","X"," ","O"," ","|",10 
                        db "6"," ","¯","|","X","X","X","|","¯"," ",10 
                        db "7"," "," ","|","X","X","X","|"," "," ",10 
                        db " "," "," "," ","¯","¯","¯"," "," "," ",10,0

    tableroDer          db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","X","X","X","|"," "," ",10
                        db "2"," ","_","|","X","X","X","|","_"," ",10
                        db "3","|","O"," "," ","X","X","X","X","|",10 
                        db "4","|"," "," "," ","X","X","X","X","|",10 
                        db "5","|"," ","O"," ","X","X","X","X","|",10 
                        db "6"," ","¯","|","X","X","X","|","¯"," ",10 
                        db "7"," "," ","|","X","X","X","|"," "," ",10 
                        db " "," "," "," ","¯","¯","¯"," "," "," ",10,0

    ; Mensajes

    msgBienvenida           db "¡Bienvenido al juego El Asalto!", 0

    msgPersonalizarTablero  db "¿Desea personalizar el tablero? (s/n): ", 0 

    msgOpcionInvalida       db "Opción inválida. Intente de nuevo.", 0

    msgPregRotacion         db "¡Se puede rotar el tablero! Elija una de las opciones (1-4):", 0
    msgRotacionesPosibles   db "1. Rotar a la izquierda", 10
                            db "2. Rotar a la derecha", 10
                            db "3. Invertir el tablero", 10
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
    msgGanador              db "¡El ganador es el equipo de los %s!", 10, 0
    stringSoldados          db "soldados", 0
    stringOficiales         db "oficiales", 0

    msgRazonGanador         db "Razón: %s", 0

    ; Se ha decidido salir de la partida
    msgSalidaPartida        db "Se ha decidido salir de la partida. ¿Desea guardarla? (y/n)", 0
    guardadoPartida         db 'n' ; guardar (y), no guardar (n)

    ; Razones de victoria de soldados
    msgSoldadosFortaleza    db "los soldados han ocupado todos los puntos de la fortaleza.", 0
    msgSoldadosRodean       db "los soldados han rodeado a los oficiales.", 0
    msgSoldadosInvalidar    db "ambos oficiales han sido invalidados."

    ; Razones de victoria de oficiales
    msgOficialesGanan       db "no quedan suficientes soldados para ocupar la fortaleza.", 0

    ; Casillas/movimientos inválidos
    msgCasillaVaciaSold     db "Casilla inválida: no hay un soldado en esa casilla.", 0
    msgCasillaVaciaOfic     db "Casilla inválida: no hay un oficial en esa casilla.", 0
    msgMovInvalidoSold      db "Movimiento inválido: no es posible mover el soldado a esa casilla.",0
    msgMovInvalidoOfic      db "Movimiento inválido: no es posible mover el oficial a esa casilla.",0

    ; Turnos
    msgTurnoSoldados        db "Es turno de los soldados. Decida a qué soldado desea mover: (F C)", 0
    msgTurnoOficiales       db "Es turno de los oficiales. Decida a qué oficial desea mover: (F C)", 0
    msgTurnoMovSold         db "¿A qué casilla desea mover el soldado? (F C)", 0
    msgTurnoMovOfic         db "¿A qué casilla desea mover el oficial? (F C)", 0

    msgCapturaSold          db "Un oficial ha capturado a un soldado.", 0
    msgInvalidOfic          db "¡Un oficial ha sido invalidado! No ha capturado a un soldado regalado.", 0
    
    ; Contadores

    movimientosOfic1        db 0
    movimientosOfic2        db 0
    
    movOfic1Adelante        db 0
    movOfic1Derecha         db 0
    movOfic1Izquierda       db 0
    movOfic1Atras           db 0
    movOfic1Diagonal        db 0

    movOfic2Adelante        db 0
    movOfic2Derecha         db 0
    movOfic2Izquierda       db 0
    movOfic2Atras           db 0
    movOfic2Diagonal        db 0

    cantSoldCapturados      db 0
    cantOficInvalidados     db 0

    simboloOficiales        db 'O', 0
    simboloSoldados         db 'X', 0
    orientacionTablero      db 4    ; 4 -> no rotar (default) 
    piezaDeInicio           db 's'  ; soldados (s), oficiales (o)


section .bss

    eleccionRotar       resd 1
    rotacionElegida     resd 1

    simbOficElegido     resd 1  ; Variable pivote para el símbolo de los oficiales
    simbSoldElegido     resd 1  ; Variable pivote para el símbolo de los soldados

    piezaIniElegida     resd 1

section .text
    global main

main:
    
    mPuts msgBienvenida

    personalizar:
        mov dword[eleccionRotar], ''    ; vaciar variable
        mPuts msgPersonalizarTablero
        mGets eleccionRotar

        cmp dword[eleccionRotar], 'n' 
        je comenzarPartida
        cmp dword[eleccionRotar], 's'
        je personalizarRotacion

        mPuts msgOpcionInvalida
        jmp personalizar

    personalizarRotacion:
        mPuts msgPregRotacion
        mPuts msgRotacionesPosibles

        mov dword[rotacionElegida], '' ; limpiar variable
        mGets rotacionElegida

        ; cmp dword[rotacionElegida], 1 ; rotar antes de símbolos
        ; je rotar1
        ; cmp dword[rotacionElegida], 2 ; rotar antes de símbolos
        ; je rotar2
        ; cmp dword[rotacionElegida], 3 ; rotar antes de símbolos
        ; je rotar3
        cmp dword[rotacionElegida], '4' ; no rotar
        je personalizarSimbolos

        mPuts msgOpcionInvalida
        jmp personalizarRotacion

    personalizarSimbolos:
        mPuts msgPersonalizarSimb

        call setearSimbSoldados
        call setearSimbOficiales
        
    personalizarQuienInicia:
        mov dword[piezaIniElegida], ''    ; vaciar variable
        mPuts msgQuienInicia
        mGets piezaIniElegida

        cmp dword[piezaIniElegida], 'o' 
        je setearPiezaInicio
        cmp dword[piezaIniElegida], 's'
        je setearPiezaInicio

        mPuts msgOpcionInvalida
        jmp personalizarQuienInicia

        setearPiezaInicio:
            mov rcx, 1
            lea rsi, [piezaIniElegida]
            lea rdi, [piezaDeInicio]
            rep movsb

            mPuts piezaDeInicio
            jmp comenzarPartida
    
    ret

comenzarPartida:
    mPuts msgJuegoTerminado

    ret


setearSimbSoldados:
    mPuts msgSimboloSoldados
    mov dword[simbSoldElegido], ''
    mGets simbSoldElegido

    cmp byte[simbSoldElegido], ' '
    je errSeteoSoldado
    cmp byte[simbSoldElegido], ''
    je errSeteoSoldado

    mov al, byte[simbSoldElegido]
    mov byte[simboloSoldados], al

    mPuts simboloSoldados
    ret

    errSeteoSoldado:
        mPuts msgOpcionInvalida
        jmp setearSimbSoldados


setearSimbOficiales:
    mPuts msgSimboloOficiales
    mov dword[simbOficElegido], ''
    mGets simbOficElegido

    cmp byte[simbOficElegido], ' '
    je errSeteoOficial
    cmp byte[simbOficElegido], ''
    je errSeteoOficial

    mov al, byte[simbOficElegido]
    mov byte[simboloOficiales], al

    mPuts simboloOficiales
    ret

    errSeteoOficial:
        mPuts msgOpcionInvalida
        jmp setearSimbOficiales