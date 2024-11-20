%macro mPuts 1 ; Imprime el string %1, hasta encontrar un 0
    mov rdi, %1
    sub rsp, 8
    call puts
    add rsp, 8
%endmacro

%macro mPrint 2 ; Imprime el string %2 con formato %1
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call printf
    add rsp, 8
%endmacro

%macro mGets 1 ; Obtiene un string por teclado, guardándolo en %1
    mov rdi, %1
    sub rsp, 8
    call gets
    add rsp, 8
%endmacro

%macro mCommand 1 ; Ejecuta el comando %1 de la terminal
    mov rdi, %1
    sub rsp, 8
    call system
    add rsp, 8
%endmacro

%macro mMov 3 ; Copia %3 bytes del campo de memoria %2 al campo de memoria %1
    mov rcx, %3
    lea rsi, [%2]
    lea rdi, [%1]
    rep movsb
%endmacro

%macro mCmp 3 ; Compara %3 bytes del campo %1 con %2
    mov rcx, %3
    lea rsi, %1
    lea rdi, %2
    repe cmpsb
%endmacro 

%macro mErrorJump 2 ; Imprime el mensaje de error %1 y salta a la etiqueta %2
    mPuts %1
    jmp %2
%endmacro

%macro mfGets 2
    mov rdi, %1
    mov rsi, %2
    mov rdx, [stdin]
    sub rsp, 8
    call fgets
    add rsp, 8
%endmacro

%macro mLeerEntradaEstandar 2
    mov rax, 0      ; syscall: read
    mov rdi, 0      ; 0: stdin
    mov rsi, %1   ; buffer (direccion de guardado de lo leido)
    mov rdx, %2     ; Cuantos bytes queremos leer
    syscall

    mov byte[rsi+rax], 0
%endmacro

%macro mSscanf 3
    lea rdi, %1     ; Variable Original string
    mov rsi, %2     ; Formato
    mov rdx, %3     ; Variable a guardar el int
    sub rsp, 8
    call sscanf
    add rsp, 8
%endmacro

%macro mAtoi 2
    lea rdi, %1
    sub rsp, 8
    call atoi
    add rsp, 8
    mov [%2], eax
%endmacro

%macro mCalcDesplaz 3
    mov rdi, %1
    mov rsi, %2
    call calcularDesplazamiento
    mov %3, rax
%endmacro

%macro mEstaVacia 1 
    mov rax, 0
    mov rdi, %1 ; recibe el desplazamiento
    call estaVacia
%endmacro

extern puts, printf
extern gets
extern system, stdin
extern fgets
extern atoi
extern sscanf

section .data

    ; Tableros y sus posibles estados

    tableroOrig         db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," ","-","_","_","_","-"," "," ",10 
                        db "1"," "," ","|","X","X","X","|"," "," ",10
                        db "2","-","_","|","X","X","X","|","_","-",10
                        db "3","|","X","X","X","X","X","X","X","|",10 
                        db "4","|","X","X","X","X","X","X","X","|",10 
                        db "5","|","X","X"," "," "," ","X","X","|",10 
                        db "6","-","-","|"," "," ","O","|","-","-",10 
                        db "7"," "," ","|","O"," "," ","|"," "," ",10 
                        db " "," "," ","-","-","-","-","-"," "," ",10,0

    tableroInv          db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","O"," "," ","|"," "," ",10
                        db "2"," ","_","|"," "," ","O","|","_"," ",10
                        db "3","|","X","X"," "," "," ","X","X","|",10 
                        db "4","|","X","X","X","X","X","X","X","|",10 
                        db "5","|","X","X","X","X","X","X","X","|",10 
                        db "6"," ","-","|","X","X","X","|","-"," ",10 
                        db "7"," "," ","|","X","X","X","|"," "," ",10 
                        db " "," "," "," ","-","-","-"," "," "," ",10,0

    tableroDer          db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","X","X","X","|"," "," ",10
                        db "2"," ","_","|","X","X","X","|","_"," ",10
                        db "3","|","X","X","X","X"," "," ","O","|",10 
                        db "4","|","X","X","X","X"," "," "," ","|",10 
                        db "5","|","X","X","X","X"," ","O"," ","|",10 
                        db "6"," ","-","|","X","X","X","|","-"," ",10 
                        db "7"," "," ","|","X","X","X","|"," "," ",10 
                        db " "," "," "," ","-","-","-"," "," "," ",10,0

    tableroIzq          db " "," ","1","2","3","4","5","6","7"," ",10
                        db " "," "," "," ","_","_","_"," "," "," ",10 
                        db "1"," "," ","|","X","X","X","|"," "," ",10
                        db "2"," ","_","|","X","X","X","|","_"," ",10
                        db "3","|","O"," "," ","X","X","X","X","|",10 
                        db "4","|"," "," "," ","X","X","X","X","|",10 
                        db "5","|"," ","O"," ","X","X","X","X","|",10 
                        db "6"," ","-","|","X","X","X","|","-"," ",10 
                        db "7"," "," ","|","X","X","X","|"," "," ",10 
                        db " "," "," "," ","-","-","-"," "," "," ",10,0

    ; Mensajes

    msgBienvenida           db "¡Bienvenido al juego El Asalto!", 0

    msgPersonalizarTablero  db "¿Desea personalizar el tablero? (s/n): ", 0 

    msgOpcionInvalida       db "Opción inválida. Intente de nuevo.", 0
    
    msgCasillaInvalidaSold  db "Casilla inválida: no hay un soldado en esa casilla. Intente de nuevo.", 0
    msgErrorInputSold       db "Error en el formato de entrada del soldado. Intente de nuevo.", 0
    msgCasillaInvMovSold    db "No se puede mover el soldado a esa casilla. Intente de nuevo.", 0

    msgCasillaInvalidaOfic  db "Casilla inválida: no hay un oficial en esa casilla. Intente de nuevo.", 0
    msgErrorInputOfic       db "Error en el formato de entrada del oficial. Intente de nuevo.", 0
    msgCasillaInvMovOfic    db "No se puede mover el oficial a esa casilla. Intente de nuevo.", 0

    msgPregRotacion         db "¡Se puede rotar el tablero! Elija una de las opciones (1-4):", 0
    msgRotacionesPosibles   db "1. Rotar a la izquierda", 10
                            db "2. Rotar a la derecha", 10
                            db "3. Invertir el tablero", 10
                            db "4. No rotar", 0
    
    msgPersonalizarSimb     db "¡Elijamos los símbolos para cada personaje! Escriba UN (1) solo caracter para cada uno.", 0
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

    ; Turnos
    msgTurnoSoldados        db "Es turno de los soldados. Decida a qué soldado desea mover: (<numFila>-<numColumna>)", 0
    msgTurnoOficiales       db "Es turno de los oficiales. Decida a qué oficial desea mover: (<numFila>-<numColumna>)", 0
    msgTurnoMovSold         db "¿A qué casilla desea mover el soldado? (<numFila>-<numColumna>)", 0
    msgTurnoMovOfic         db "¿A qué casilla desea mover el oficial? (<numFila>-<numColumna>)", 0

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
    
    orientacionTablero      db  4       ; 4 -> no rotar (default) 
    piezaDeInicio           db 's'      ; soldados (s), oficiales (o)

    ; Comandos 
    cmdLimpiarPantalla      db "clear", 0

    ; Formatos
    formatoAtoi             db "%u", 0

section .bss

    eleccionRotar       resd 1  ; Variable pivote para la elección de rotar el tablero
    rotacionElegida     resd 1  ; Variable pivote para la rotación del tablero

    simbOficElegido     resb 2  ; Variable pivote para el símbolo de los oficiales
    simbSoldElegido     resb 2  ; Variable pivote para el símbolo de los soldados

    piezaIniElegida     resd 1  ; Variable pivote para la pieza que inicia

    tableroEnJuego      resb 116 ; Tablero en juego

    soldadoElegido      resb 4  ; Fila y columna del soldado a mover
    casillaMovSold      resb 4  ; Fila y columna de la casilla de destino del soldado

    oficialElegido      resb 4  ; Fila y columna del oficial a mover
    casillaMovOfic      resb 4  ; Fila y columna de la casilla de destino del oficial

    fila                resq 1
    columna             resq 1   
    desplazCasOrig      resq 1

    filaAMover          resq 1
    columnaAMover       resq 1
    desplazCasAMover    resq 1

    filaAux             resq 1
    columnaAux          resq 1
    desplazAux       resq 1
    
    msgErrorEspecificoSold  resb 71 ; Máximo largo de mensaje de error para soldados
    msgErrorEspecificoOfic  resb 71 ; Máximo largo de mensaje de error para oficiales

    msgErrorEspecificoSoldMov   resb 71 ; Máximo largo de mensaje de error para movimientos de soldados
    msgErrorEspecificoOficMov   resb 71 ; Máximo largo de mensaje de error para movimientos de oficiales

section .text
    global main

main:

    mPuts msgBienvenida

    ; Espacio de personalización del tablero
    personalizar:
        mov dword[eleccionRotar], ''    ; vaciar variable
        mPuts msgPersonalizarTablero
        mGets eleccionRotar

        cmp dword[eleccionRotar], 'n' 
        je dejarTableroOrig
        cmp dword[eleccionRotar], 's'
        je personalizarRotacion

        mErrorJump msgOpcionInvalida, personalizar

    ; En caso de querer personalizar, se debe elegir la rotación
    personalizarRotacion:
        mPuts msgPregRotacion
        mPuts msgRotacionesPosibles

        mov dword[rotacionElegida], '' ; limpiar variable
        mGets rotacionElegida

        mMov orientacionTablero, rotacionElegida, 1
        
        cmp dword[rotacionElegida], '1'
        jl invalidaRotacion
        cmp dword[rotacionElegida], '4'
        jg invalidaRotacion

        jmp rotarTablero

    invalidaRotacion:
        mErrorJump msgOpcionInvalida, personalizarRotacion

    ; Luego de elegir la rotación, se debe personalizar los símbolos
    personalizarSimbolos:
        mPuts msgPersonalizarSimb

        call setearSimbSoldados
        call setearSimbOficiales
        
    ; Luego de personalizar los símbolos, se debe elegir quién inicia la partida
    personalizarQuienInicia:
        mov dword[piezaIniElegida], ''    ; vaciar variable
        mPuts msgQuienInicia
        mGets piezaIniElegida

        cmp dword[piezaIniElegida], 'o' 
        je setearPiezaInicio
        cmp dword[piezaIniElegida], 's'
        je setearPiezaInicio

        mErrorJump msgOpcionInvalida, personalizarQuienInicia

        setearPiezaInicio:
            mMov piezaDeInicio, piezaIniElegida, 1
            jmp comenzarPorInicio

; --------------------------------------------------------------------------------------------
; RUTINA PARA ROTAR EL TABLERO EN BASE A LA ELECCIÓN DEL USUARIO
; --------------------------------------------------------------------------------------------

rotarTablero:
    ; Se debe mostrar el tablero (en la orientacion indicada y con los simbolos indicados), 
    ; y se debe mostrar el mensaje de turno en base a lo que haya personalizado el usuario.
        cmp byte[orientacionTablero], '1'
        je rotarIzquierda
        cmp byte[orientacionTablero], '2'
        je rotarDerecha
        cmp byte[orientacionTablero], '3'
        je rotarInvertir

        mMov tableroEnJuego, tableroOrig, 116
        jmp personalizarSimbolos

    rotarIzquierda:
        mMov tableroEnJuego, tableroIzq, 116
        jmp personalizarSimbolos
    
    rotarDerecha:
        mMov tableroEnJuego, tableroDer, 116
        jmp personalizarSimbolos

    rotarInvertir:
        mMov tableroEnJuego, tableroInv, 116
        jmp personalizarSimbolos

; --------------------------------------------------------------------------------------------
; RUTINA PARA COMENZAR EL JUEGO -> Se comienza desde el jugador elegido (o el default)
; --------------------------------------------------------------------------------------------

comenzarPorInicio:
    cmp byte[piezaDeInicio], 's'
    je loopMovimientos
    cmp byte[piezaDeInicio], 'o'
    je turnoOficiales


; En caso de no haber personalizado el tablero, se debe dejar el tablero original
dejarTableroOrig:
    mMov tableroEnJuego, tableroOrig, 116

; COMIENZA EL JUEGO
loopMovimientos:; mostrarTablero, mostrarTurno, realizarMovimiento, verificarFinJuego
    mov byte[msgErrorEspecificoSold], 0
    turnoSoldados:
        mov byte [soldadoElegido], '0'
    
        mCommand cmdLimpiarPantalla ; Limpia la pantalla para mostrar el tablero

        mPuts tableroEnJuego ; Muestro el tablero

        cmp byte[msgErrorEspecificoSold], 0
        jne imprimirErrorSold

        todoOkSold:

            mPuts msgTurnoSoldados      ; Muestra el mensaje de seleccionar ficha a mover
            mGets soldadoElegido        ; Obtiene la ficha a mover
            
            jmp verificarFichaSold ; Verifica si la ficha elegida es valida

            casillaAMoverseSold:
                
                mPuts msgTurnoMovSold   ; Muestra el mensaje de seleccionar casilla a mover
                mGets casillaMovSold    ; Obtiene la casilla a mover

                jmp verificarMovimientoSold ; Verifica si el movimiento es valido

                moverSoldado:
                    call realizarMovimientoSold ; Realiza el movimiento

    mov byte[msgErrorEspecificoOfic], 0
    turnoOficiales:
        mov byte[oficialElegido], '0'
        
        mCommand cmdLimpiarPantalla ; Limpia la pantalla para mostrar el tablero

        mPuts tableroEnJuego ; Muestra el tablero

        cmp byte[msgErrorEspecificoOfic], 0
        jne imprimirErrorOfic

        todoOkOfic:

            mPuts msgTurnoOficiales ; Muestra el mensaje de seleccionar ficha a mover
            mGets oficialElegido    ; Obtiene la ficha a mover

            jmp verificarFichaOfic ; Verifica si la ficha elegida es valida

            casillaAMoverseOfic:

                mPuts msgTurnoMovOfic   ; Muestra el mensaje de seleccionar casilla a mover
                mGets casillaMovOfic    ; Obtiene la casilla a mover
                
                jmp verificarMovimientoOfic ; Verifica si el movimiento es valido

                moverOficial:
                    call realizarMovimientoOfic ; Realiza el movimiento
                    jmp loopMovimientos
                
                capturar:
                    call capturarSoldado ; Captura soldado
                    
                ; Repetir en loop
                jmp loopMovimientos

    ret
    ; Aquí termina el main !!!


; --------------------------------------------------------------------------------------------
; RUTINAS PARA SETEAR LOS SÍMBOLOS PERSONALIZADOS DE SOLDADOS Y OFICIALES
; --------------------------------------------------------------------------------------------

setearSimbSoldados:
    mPuts msgSimboloSoldados
    mov byte[simbSoldElegido], ''
    mGets simbSoldElegido

    cmp byte[simbSoldElegido], ' '
    je errSeteoSoldado
    cmp byte[simbSoldElegido], ''
    je errSeteoSoldado

    mov al, byte[simbSoldElegido+1]
    cmp al, 0
    jne errSeteoSoldado

    mMov simboloSoldados, simbSoldElegido, 1

    call cambiarTableroSoldNuevo

    ret

    errSeteoSoldado:
        mErrorJump msgOpcionInvalida, setearSimbSoldados

setearSimbOficiales:
    mPuts msgSimboloOficiales
    mov dword[simbOficElegido], ''
    mGets simbOficElegido

    cmp byte[simbOficElegido], ' '
    je errSeteoOficial
    cmp byte[simbOficElegido], ''
    je errSeteoOficial

    mov al, byte[simbOficElegido+1]
    cmp al, 0
    jne errSeteoOficial

    mMov simboloOficiales, simbOficElegido, 1

    call cambiarTableroOficNuevo

    ret

    errSeteoOficial:
        mPuts msgOpcionInvalida
        jmp setearSimbOficiales

; --------------------------------------------------------------------------------------------
; VERIFICACIONES DE PIEZAS ORIGINALES A MOVER PARA SOLDADOS Y OFICIALES
; --------------------------------------------------------------------------------------------

verificarFichaSold:
    mov al, byte[soldadoElegido] ; Numero de fila
    
    cmp al, '1'
    jl errorInputSold
    cmp al, '7'
    jg errorInputSold

    mov qword[fila], 0
    mSscanf byte[soldadoElegido], formatoAtoi, fila

    cmp rax, 1
    jl errorInputSold

    mov al, byte[soldadoElegido+1] ; Caracter '-'
    cmp al, '-'
    jne errorInputSold
    
    mov al, byte[soldadoElegido+2] ; Numero de columna
    cmp al, '1'
    jl errorInputSold
    cmp al, '7'
    jg errorInputSold

    mov qword[columna], 0
    mSscanf byte[soldadoElegido+2], formatoAtoi, columna

    cmp rax, 1
    jl errorInputSold

    mov al, byte[soldadoElegido+3] ; Caracter nulo
    cmp al, 0
    jne errorInputSold

    ; Calculamos desplazamiento en tablero
    mCalcDesplaz [fila], [columna], qword[desplazCasOrig]
    mov rbx, qword[desplazCasOrig]
    
    mov rax,0
    mov rdx, 0

    mov dl, byte[tableroEnJuego+rbx]
    mov al, [simboloSoldados]

    cmp dl, al
    jne errorCasillaInvalidaSold
    
    mov rax, 0
    mov [msgErrorEspecificoSold], rax
    jmp casillaAMoverseSold

    errorInputSold:
        mov rax, [msgErrorInputSold]
        mMov msgErrorEspecificoSold, msgErrorInputSold, 61
        jmp turnoSoldados

    errorCasillaInvalidaSold:
        mov rax, [msgCasillaInvalidaSold]
        mMov msgErrorEspecificoSold, msgCasillaInvalidaSold, 71
        jmp turnoSoldados

    imprimirErrorSold:
        mPuts msgErrorEspecificoSold
        jmp todoOkSold
    

verificarFichaOfic:
    mov cl, byte[oficialElegido] ; Numero de fila
    
    cmp cl, '1'
    jl errorInputOfic
    cmp cl, '7'
    jg errorInputOfic
    
    mov qword[fila], 0
    mSscanf byte[oficialElegido], formatoAtoi, fila

    cmp rax, 1
    jl errorInputOfic

    mov cl, byte[oficialElegido+1] ; Caracter '-'
    cmp cl, '-'
    jne errorInputOfic
    
    mov cl, byte[oficialElegido+2] ; Numero de columna
    cmp cl, '1'
    jl errorInputOfic
    cmp cl, '7'
    jg errorInputOfic

    mov qword[columna], 0
    mSscanf byte[oficialElegido+2], formatoAtoi, columna

    cmp rax, 1
    jl errorInputOfic

    mov cl, byte[oficialElegido+3] ; Caracter nulo
    cmp cl, 0
    jne errorInputOfic

    ; Calculamos desplazamiento en tablero
    mCalcDesplaz [fila], [columna], qword[desplazCasOrig]
    mov rbx, qword[desplazCasOrig]
    
    mov rax, 0
    mov rdx, 0

    mov dl, byte[tableroEnJuego+rbx]
    mov cl, [simboloOficiales]

    cmp dl, cl
    jne errorCasillaInvalidaOfic
    
    mov rax, 0
    mov [msgErrorEspecificoOfic], rax
    jmp casillaAMoverseOfic

    errorInputOfic:
        mov rax, [msgErrorInputOfic]
        mMov msgErrorEspecificoOfic, msgErrorInputOfic, 61
        jmp turnoOficiales

    errorCasillaInvalidaOfic:
        mov rax, [msgErrorInputOfic]
        mMov msgErrorEspecificoOfic, msgCasillaInvalidaOfic, 71
        jmp turnoOficiales

    imprimirErrorOfic:
        mPuts msgErrorEspecificoOfic
        jmp todoOkOfic

; --------------------------------------------------------------------------------------------
; VERFICIACIONES DE CASILLAS DESTINO PARA SOLDADOS Y OFICIALES
; --------------------------------------------------------------------------------------------

verificarMovimientoSold:
    mov al, byte[casillaMovSold] ; Numero de fila
    
    cmp al, '1'
    jl errorInputSoldMov
    cmp al, '7'
    jg errorInputSoldMov

    mov qword[filaAMover], 0
    mSscanf byte[casillaMovSold], formatoAtoi, filaAMover

    cmp rax, 1
    jl errorInputSoldMov

    mov al, byte[casillaMovSold+1] ; Caracter '-'
    cmp al, '-'
    jne errorInputSoldMov
    
    mov al, byte[casillaMovSold+2] ; Numero de columna
    cmp al, '1'
    jl errorInputSoldMov
    cmp al, '7'
    jg errorInputSoldMov

    mov qword[columnaAMover], 0
    mSscanf byte[casillaMovSold+2], formatoAtoi, columnaAMover

    cmp rax, 1
    jl errorInputSoldMov

    mov al, byte[casillaMovSold+3] ; Caracter nulo
    cmp al, 0
    jne errorInputSoldMov

    ; Primero chequeamos si el soldado original está en alguna de las posiciones especiales
    call chequearSoldPosEspeciales
    cmp rax, 0
    je lugaresComunesSold ; Si recibimos 1, la casilla original es un lugar común: intentamos hacer el movimiento normal
    
    cmp rax, 1 ; Si recibimos 1, la casilla original es un lugar especial: solo podemos movernos a la derecha
    je soloDerechaSold
    cmp rax, 2 ; Si recibimos 2, la casilla original es un lugar especial: solo podemos movernos a la izquierda
    je soloIzquierdaSold
    
    casillaEspecialAMover:
        cmp r8, 0
        jne errorCasillaInvalidaSoldMov
        jmp moverSoldado

    lugaresComunesSold:
        ; Comparamos la fila a mover con la fila actual
        mMov filaAux, fila, 1
        inc qword[filaAux]
        mCmp [filaAux], [filaAMover], 1
        jne errorCasillaInvalidaSoldMov

        ; Comparamos la columna a mover con la columna actual
        mov qword[columnaAux], 0 ; Reiniciamos la columna auxiliar
        mMov columnaAux, columna, 1

        mCmp [columnaAux], [columnaAMover], 1 ; Movimiento hacia adelante
        je columnaSoldAMoverValida

        inc qword[columnaAux]
        mCmp [columnaAux], [columnaAMover], 1 ; Movimiento diagonal hacia la izquierda
        je columnaSoldAMoverValida

        sub qword[columnaAux], 2
        mCmp [columnaAux], [columnaAMover], 1 ; Movimiento diagonal hacia la derecha
        je columnaSoldAMoverValida

        jmp errorCasillaInvalidaSoldMov

    columnaSoldAMoverValida: ; Queda ver si en esa casilla está vacía o no
        mCalcDesplaz [filaAMover], [columnaAMover], qword[desplazCasAMover]
        mEstaVacia qword[desplazCasAMover]
        cmp rax, 1
        je errorCasillaInvalidaSoldMov ; Si recibimos 1, la casilla está ocupada (o está fuera del tablero)
        
        jmp moverSoldado 


    errorInputSoldMov:
        mov rax, [msgErrorInputSold]
        mMov msgErrorEspecificoSold, msgErrorInputSold, 61
        jmp turnoSoldados

    errorCasillaInvalidaSoldMov:
        mov rax, [msgCasillaInvMovSold]
        mMov msgErrorEspecificoSold, msgCasillaInvMovSold, 61
        jmp turnoSoldados

    imprimirErrorSoldMov:
        mPuts msgErrorEspecificoSold
        jmp turnoSoldados

    soloDerechaSold:
        mov r8, 1 ; Suponemos que el movimiento es inválido

        mCalcDesplaz [filaAMover], [columnaAMover], qword[desplazCasAMover]
        mEstaVacia qword[desplazCasAMover]
        cmp rax, 1 
        je casillaEspecialAMover

        mCmp [fila], [filaAMover], 1 ; Las filas deben ser iguales (el movimiento especial es para el costado)
        jne casillaEspecialAMover

        mMov columnaAux, columna, 1
        inc qword[columnaAux]
        mCmp [columnaAux], [columnaAMover], 1
        jne casillaEspecialAMover
        
        mov r8, 0 ; Si llegamos acá, el movimiento es válido
        jmp casillaEspecialAMover
    
    soloIzquierdaSold:
        mov r8, 1 ; Suponemos que el movimiento es inválido

        mCalcDesplaz [filaAMover], [columnaAMover], qword[desplazCasAMover]
        mEstaVacia qword[desplazCasAMover]
        cmp rax, 1 
        je casillaEspecialAMover

        mCmp [fila], [filaAMover], 1 ; Las filas deben ser iguales (el movimiento especial es para el costado)
        jne casillaEspecialAMover

        mMov columnaAux, columna, 1
        dec qword[columnaAux]
        mCmp [columnaAux], [columnaAMover], 1
        jne casillaEspecialAMover

        mov r8, 0 ; Si llegamos acá, el movimiento es válido
        jmp casillaEspecialAMover
    
    ret

verificarMovimientoOfic:
    mov al, byte[casillaMovOfic] ; Numero de fila
    
    cmp al, '1'
    jl errorInputOficMov
    cmp al, '7'
    jg errorInputOficMov

    mov qword[filaAMover], 0
    mSscanf byte[casillaMovOfic], formatoAtoi, filaAMover

    cmp rax, 1
    jl errorInputOficMov

    mov al, byte[casillaMovOfic+1] ; Caracter '-'
    cmp al, '-'
    jne errorInputOficMov
    
    mov al, byte[casillaMovOfic+2] ; Numero de columna
    cmp al, '1'
    jl errorInputOficMov
    cmp al, '7'
    jg errorInputOficMov

    mov qword[columnaAMover], 0
    mSscanf byte[casillaMovOfic+2], formatoAtoi, columnaAMover

    cmp rax, 1
    jl errorInputOficMov

    mov al, byte[casillaMovOfic+3] ; Caracter nulo
    cmp al, 0
    jne errorInputOficMov

    ; Comparamos la fila a mover con la fila actual
    mMov filaAux, fila, 1

    mCmp [filaAux], [filaAMover], 1
    je filaOficAMoverValida ; Filas iguales -> válido
    inc qword[filaAux]
    mCmp [filaAux], [filaAMover], 1
    je filaOficAMoverValida
    sub qword[filaAux], 2
    mCmp [filaAux], [filaAMover], 1
    je filaOficAMoverValida

    jmp errorCasillaInvalidaOficMov

    filaOficAMoverValida:
        ; Comparamos la columna a mover con la columna actual
        mov qword[columnaAux], 0 ; Reiniciamos la columna auxiliar
        mMov columnaAux, columna, 1

        mCmp [columnaAux], [columnaAMover], 1 ; Movimiento hacia adelante
        je columnaOficAMoverValida

        inc qword[columnaAux]
        mCmp [columnaAux], [columnaAMover], 1 ; Movimiento diagonal hacia la izquierda
        je columnaOficAMoverValida

        sub qword[columnaAux], 2
        mCmp [columnaAux], [columnaAMover], 1 ; Movimiento diagonal hacia la derecha
        je columnaOficAMoverValida

        jmp errorCasillaInvalidaOficMov

    columnaOficAMoverValida: ; Podríamos hacer un movimiento normal (casilla vacía) o capturar un soldado...
        mCalcDesplaz [filaAMover], [columnaAMover], qword[desplazCasAMover]
        mEstaVacia qword[desplazCasAMover]
        cmp rax, 0
        je moverOficial ; Si llegamos acá, la casilla a mover está vacía -> movimiento normal
        
        ; Si llegamos acá, la casilla no está vacía: ver si hay un soldado para capturar
        call casillaAMoverHaySoldado
        cmp rax, 1
        je errorCasillaInvalidaOficMov ; Si recibimos 1, la casilla a ocupar no tiene un soldado -> movimiento inválido

        ; Si llegamos acá, la casilla a ocupar tiene un soldado: debemos ver si el oficial puede saltar sobre él...
        call sePuedeSaltarSoldado
        cmp rax, 1
        je errorCasillaInvalidaOficMov ; Si recibimos 1, el oficial no puede saltar sobre el soldado -> movimiento inválido

        jmp capturar


    errorInputOficMov:
        mov rax, [msgErrorInputOfic]
        mMov msgErrorEspecificoOfic, msgErrorInputOfic, 61
        jmp turnoOficiales

    errorCasillaInvalidaOficMov:
        mov rax, [msgCasillaInvMovOfic]
        mMov msgErrorEspecificoOfic, msgCasillaInvMovOfic, 61
        jmp turnoOficiales

    imprimirErrorOficMov:
        mPuts msgErrorEspecificoOfic
        jmp turnoOficiales

; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR SI UNA CASILLA ESTÁ VACÍA
; --------------------------------------------------------------------------------------------

estaVacia:
    cmp byte[tableroEnJuego+rdi], ' '
    je okVacia

    mov rax, 1
    ret

    okVacia:
        mov rax, 0
        ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA CALCULAR EL DESPLAZAMIENTO DE UNA CASILLA EN EL TABLERO
; --------------------------------------------------------------------------------------------

calcularDesplazamiento:
    mov rax, 0
    mov rax, rdi
    inc rax
    imul ax, 11
    add rax, rsi
    inc rax

    ret

; --------------------------------------------------------------------------------------------
; RUTINAS PARA REALIZAR MOVIMIENTOS SIMPLES DE SOLDADOS Y OFICIALES (los que no requieren capturas)
; --------------------------------------------------------------------------------------------

realizarMovimientoSold:
    mov rax, qword[desplazCasOrig]
    mov rbx, qword[desplazCasAMover]

    mov byte[tableroEnJuego+rax], ' '
    mMov tableroEnJuego+rbx, simboloSoldados, 1

    ret

realizarMovimientoOfic:
    mov rax, qword[desplazCasOrig]
    mov rbx, qword[desplazCasAMover]

    mov byte[tableroEnJuego+rax], ' '
    mMov tableroEnJuego+rbx, simboloOficiales, 1

    ret
    
; --------------------------------------------------------------------------------------------
; RUTINAS PARA CAMBIAR EL TABLERO CON LOS SIMBOLOS PERSONALIZADOS
; --------------------------------------------------------------------------------------------

cambiarTableroSoldNuevo:
    mov rbx, 26 ; Desplazamiento de la primera casilla en donde puede haber piezas

    cicloCambiarSoldados:
        cmp byte[tableroEnJuego+rbx], 'X'
        jne noCambiarSoldado
        mMov tableroEnJuego+rbx, simboloSoldados, 1 ; Cambio el simbolo de los soldados

        noCambiarSoldado:
            inc rbx
            cmp rbx, 75 ; Desplazamiento de la última casilla en donde puede haber piezas
            jl cicloCambiarSoldados

    ret

cambiarTableroOficNuevo:
    mMov tableroEnJuego+83, simboloOficiales, 1 ; Primer oficial (desplazamiento)
    mMov tableroEnJuego+92, simboloOficiales, 1 ; Segundo oficial (desplazamiento)
    ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA CHEQUEAR SI LA CASILLA DE ORIGEN DE UN SOLDADO ES UNA POSICIÓN ESPECIAL
; --------------------------------------------------------------------------------------------

chequearSoldPosEspeciales:
    mov rax, 0

    cmp qword[fila], 5
    jne noEsLugarEspecial ; Si la fila no es 5, no estamos en una posición especial

    ; Si la columna es 1 o 2 (fila 5), estamos en una posición especial: solo podemos movernos a la derecha
    cmp qword[columna], 1
    je esLugarEspecialADer 
    cmp qword[columna], 2
    je esLugarEspecialADer 

    ; Si la columna es 6 o 7 (fila 5), estamos en una posición especial: solo podemos movernos a la izquierda
    cmp qword[columna], 6
    je esLugarEspecialAIzq 
    cmp qword[columna], 7
    je esLugarEspecialAIzq

    noEsLugarEspecial:
        ret

    esLugarEspecialAIzq:
        mov rax, 2
        ret
    
    esLugarEspecialADer:
        mov rax, 1
        ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR SI HAY UN SOLDADO EN LA CASILLA DESTINO
; --------------------------------------------------------------------------------------------

casillaAMoverHaySoldado:
    ; Calculamos desplazamiento en tablero
    mCalcDesplaz [filaAMover], [columnaAMover], qword[desplazCasAMover]
    mov rbx, qword[desplazCasAMover]

    mCmp byte[tableroEnJuego+rbx], simboloSoldados, 1
    je casillaConSoldado

    mov rax, 1
    ret

    casillaConSoldado:
        mov rax, 0
        ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR SI UN OFICIAL PUEDE SALTAR SOBRE UN SOLDADO
; --------------------------------------------------------------------------------------------

sePuedeSaltarSoldado:
    mov rax, qword[fila]
    mov rbx, qword[filaAMover]
    sub rax, rbx
    jg saltoHaciaArriba ; Si la fila original es mayor que la fila destino, el salto es hacia arriba
    jl saltoHaciaAbajo ; Si la fila original es menor que la fila destino, el salto es hacia abajo

    ; Si estamos acá, el salto es en la misma fila
    mov rax, qword[columna]
    mov rbx, qword[columnaAMover]

    sub rax, rbx
    jg saltoHaciaIzq ; Si la columna original es mayor que la columna destino, el salto es hacia la izquierda
    jl saltoHaciaDer ; Si la columna original es menor que la columna destino, el salto es hacia la derecha

    saltoHaciaIzq:
        mMov filaAux, filaAMover, 1
        mMov columnaAux, columnaAMover, 1
        dec qword[columnaAux]

        mCalcDesplaz [filaAux], [columnaAux], qword[desplazAux]
        mEstaVacia qword[desplazAux]
        cmp rax, 1
        je saltoInvalido

        mov rax, 0
        ret

    saltoHaciaDer:
        mMov filaAux, filaAMover, 1
        mMov columnaAux, columnaAMover, 1
        inc qword[columnaAux]

        mCalcDesplaz [filaAux], [columnaAux], qword[desplazAux]
        mEstaVacia qword[desplazAux]
        cmp rax, 1
        je saltoInvalido

        mov rax, 0
        ret

    saltoHaciaArriba:
        mMov filaAux, filaAMover, 1
        mMov columnaAux, columnaAMover, 1
        dec qword[filaAux]
        
        mCmp [columna], [columnaAMover], 1
        je seguirSaltoArriba ; Si las columnas son iguales, el salto es hacia arriba y en línea recta
        jg haciaArribaIzq ; Si la columna original es mayor que la columna destino, el salto es hacia la izquierda

        inc qword[columnaAux] ; Salto hacia arriba y a la derecha
        jmp seguirSaltoArriba

        haciaArribaIzq:
            dec qword[columnaAux] ; Salto hacia arriba y a la izquierda

        seguirSaltoArriba:
            mCalcDesplaz [filaAux], [columnaAux], qword[desplazAux]
            mEstaVacia qword[desplazAux]
            cmp rax, 1
            je saltoInvalido

            mov rax, 0
            ret

    saltoHaciaAbajo:
        mMov filaAux, filaAMover, 1
        mMov columnaAux, columnaAMover, 1
        inc qword[filaAux]
        
        mCmp [columna], [columnaAMover], 1
        je seguirSaltoAbajo ; Si las columnas son iguales, el salto es hacia abajo y en línea recta
        jg haciaAbajoIzq ; Si la columna original es mayor que la columna destino, el salto es hacia la izquierda

        inc qword[columnaAux] ; Salto hacia abajo y a la derecha
        jmp seguirSaltoAbajo

        haciaAbajoIzq:
            dec qword[columnaAux] ; Salto hacia abajo y a la izquierda

        seguirSaltoAbajo:
            mCalcDesplaz [filaAux], [columnaAux], qword[desplazAux]
            mEstaVacia qword[desplazAux]
            cmp rax, 1
            je saltoInvalido

            mov rax, 0
            ret

    saltoInvalido:
        mov rax, 1
        ret

    ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA CAPTURAR UN SOLDADO
; --------------------------------------------------------------------------------------------

capturarSoldado:
    mov rax, qword[desplazCasOrig] ; Oficial a mover
    mov rbx, qword[desplazCasAMover] ; Soldado a capturar
    mov rcx, qword[desplazAux] ; Casilla destino del oficial (donde va a quedar)

    mov byte[tableroEnJuego+rax], ' '
    mov byte[tableroEnJuego+rbx], ' '
    
    mov dl, byte[simboloOficiales]
    mov byte[tableroEnJuego+rcx], dl

    inc qword[cantSoldCapturados] ; Aumentamos el contador de capturas

    ret
