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

%macro mSprintf 3
    mov rdi, %1     ; Variable donde se guardará el string
    mov rsi, %2     ; Formato
    mov rdx, %3     ; Variable a guardar en el string
    sub rsp, 8
    call sprintf
    add rsp, 8
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

%macro mHaySoldado 1
    mov rax, 0
    mov rdi, %1 ; recibe el desplazamiento
    call haySoldado
%endmacro

%macro mPuedeCapturar 2
    mov rdi, %1 ; diferencia de desplazamiento
    mov rsi, %2 ; 0 para sumar [rdi] al desplazamiento, 1 para restar
    call podiaComerPieza
%endmacro

%macro mOpenFile 2
    mov rdi, %1 ; nombre del archivo
    mov rsi, %2 ; modo de apertura
    sub rsp, 8
    call fopen
    add rsp, 8
    mov qword[idArchGuardado], rax ; Guardamos el ID del archivo
%endmacro

%macro mCloseFile 1
    mov rdi, [%1] ; ID del archivo
    sub rsp, 8
    call fclose
    add rsp, 8
%endmacro

%macro mReadLine 3 
    mov rdi, %1 ; lugar a dejar lo leido
    mov rsi, %2 ; cantidad de bytes a leer
    mov rdx, %3 ; bloques de lectura
    mov rcx, [idArchGuardado] ; ID del archivo
    sub rsp, 8
    call fread
    add rsp, 8
%endmacro

%macro mWriteLine 3
    mov rdi, %1 ; string a escribir
    mov rsi, %2 ; cantidad de bytes a escribir
    mov rdx, %3 ; bloques de escritura
    mov rcx, [idArchGuardado] ; ID del archivo
    sub rsp, 8
    call fwrite
    add rsp, 8
%endmacro

; Importación de funciones de la librería C
extern puts, printf
extern gets
extern system, stdin
extern sscanf, sprintf
extern fopen, fclose, fread, fwrite, fgets

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

    ; Mensajes

    msgBienvenida           db "¡Bienvenido al juego El Asalto! ('#' para salir)", 0

    msgOpcionInvalida       db "Opción inválida. Intente de nuevo.", 0
    
    msgCasillaInvalidaSold  db "Casilla inválida: no hay un soldado en esa casilla. Intente de nuevo.", 0
    msgErrorInputSold       db "Error en el formato de entrada del soldado. Intente de nuevo.", 0
    msgCasillaInvMovSold    db "No se puede mover el soldado a esa casilla. Intente de nuevo.", 0

    msgCasillaInvalidaOfic  db "Casilla inválida: no hay un oficial en esa casilla. Intente de nuevo.", 0
    msgErrorInputOfic       db "Error en el formato de entrada del oficial. Intente de nuevo.", 0
    msgCasillaInvMovOfic    db "No se puede mover el oficial a esa casilla. Intente de nuevo.", 0

    msgCapturaSold          db "Un oficial ha capturado a un soldado.", 0
    msgOficialRetirado      db "Se ha retirado a un oficial! No ha capturado a un soldado.", 0
    
    msgQuienInicia          db "¿Quién inicia el juego: oficiales o soldados? (o/s): ", 0

    msgEstadisticas         db "Estadísticas de los oficiales:", 10, 0

    msgCantTotalCapturas    db "Cantidad total de capturas: %d", 10, 10, 0

    msgOficial1             db "Oficial 1:", 10, 0
    msgOficial2             db "Oficial 2:", 10, 0

    msgCantMovimientos      db "Movimientos totales: %d", 10, 0
    msgCantAdelante         db "- Hacia adelante: %d", 10, 0
    msgCantDerecha          db "- Hacia la derecha: %d", 10, 0
    msgCantIzquierda        db "- Hacia la izquierda: %d", 10, 0
    msgCantAtras            db "- Hacia atrás: %d", 10, 0
    msgCantDiagonal         db "- En diagonal: %d", 10, 0
    msgCantDiagArribaDer    db "--- Adelante-derecha: %d", 10, 0
    msgCantDiagArribaIzq    db "--- Adelante-izquierda: %d", 10, 0
    msgCantDiagAbajoDer     db "--- Atrás-derecha: %d", 10, 0
    msgCantDiagAbajoIzq     db "--- Atrás-izquierda: %d", 10, 0

    msgCantSoldadosCapt     db "Cantidad de soldados capturados: %d", 10, 10, 0

    msgJuegoTerminado       db "¡El juego ha terminado!", 10, 0
    msgGanador              db "¡El ganador es el equipo de los %s!", 10, 0
    stringSoldados          db "soldados", 0
    stringOficiales         db "oficiales", 0

    msgRazonGanador         db "Razón: %s", 10, 0

    varRazonFin             db '----', 0 ; Razón de fin de juego (a llenar)          

    ; Se ha decidido salir de la partida
    msgSalidaPartida        db "Se ha decidido salir de la partida. ¿Desea guardarla? (s/n)", 0
    msgAclaracionSalida     db "NOTA: Si decide no guardar la partida, se perderá todo el progreso. En cambio, si decide guardarla y tenía una partida guardada, se sobreescribirá.", 0
    guardadoPartida         db 'n', 0 ; guardar (s), no guardar (n)

    yaHabiaGuardado         db 'n', 0 ; ya había guardado (s), no había guardado (n)

    turnoDe                 db 's', 0 ; soldados (s), oficiales (o)

    msgPartidaGuardada      db "¡Partida guardada con éxito!", 0

    msgErrorOpenFile        db "Error al abrir el archivo.", 0

    ; Razones de victoria de soldados
    msgSoldadosFortaleza    db "los soldados han ocupado todos las casillas de la fortaleza.", 0
    msgSoldadosRodean       db "los soldados han rodeado a los oficiales.", 0
    msgSoldadosInvalidar    db "ambos oficiales han sido invalidados.", 0

    ; Razones de victoria de oficiales
    msgOficialesGanan       db "no quedan suficientes soldados para ocupar la fortaleza.", 0

    ; Turnos
    msgTurnoSoldados        db "Es turno de los soldados. Decida a qué soldado desea mover: (<numFila>-<numColumna>)", 0
    msgTurnoOficiales       db "Es turno de los oficiales. Decida a qué oficial desea mover: (<numFila>-<numColumna>)", 0
    msgTurnoMovSold         db "¿A qué casilla desea mover el soldado? (<numFila>-<numColumna>)", 0
    msgTurnoMovOfic         db "¿A qué casilla desea mover el oficial? (<numFila>-<numColumna>)", 0
    
    ; Contadores

    movimientosOfic1        dq 0
    movimientosOfic2        dq 0
    
    movOfic1Adelante        dq 0
    movOfic1Derecha         dq 0
    movOfic1Izquierda       dq 0
    movOfic1Atras           dq 0
    movOfic1Diagonal        dq 0
    movOfic1DiagArribaDer   dq 0
    movOfic1DiagArribaIzq   dq 0
    movOfic1DiagAbajoDer    dq 0
    movOfic1DiagAbajoIzq    dq 0

    movOfic2Adelante        dq 0
    movOfic2Derecha         dq 0
    movOfic2Izquierda       dq 0
    movOfic2Atras           dq 0
    movOfic2Diagonal        dq 0
    movOfic2DiagArribaDer   dq 0
    movOfic2DiagArribaIzq   dq 0
    movOfic2DiagAbajoDer    dq 0
    movOfic2DiagAbajoIzq    dq 0

    cantSoldCapturados      dq 0 ; Cuando haya 16 soldados capturados, los oficiales ganan
    cantOficInvalidados     dq 0 ; Cuando haya 2 oficiales invalidados, los soldados ganan

    casillaOfic1            dq 7,3
    casillaOfic2            dq 6,5

    cantCapturasOfic1       dq 0
    cantCapturasOfic2       dq 0

    simboloOficiales        db 'O', 0
    simboloSoldados         db 'X', 0
    
    orientacionTablero      db  4       ; 4 -> no rotar (default) 
    piezaDeInicio           db 's'      ; soldados (s), oficiales (o)

    ; Comandos 
    cmdLimpiarPantalla          db "clear", 0
    cmdCrearArchivoPartida      db "touch partidaGuardada.dat", 0
    cmdBorrarArchivoPartida     db "rm partidaGuardada.dat", 0
    cmdLimpiarArchivo           db "echo -n > partidaGuardada.dat", 0

    ; Formatos
    formatoAtoi             db "%u", 0
    formatoItoa             db "%s", 0

    ; Modos de apertura de archivos
    modoLectura             db "rb", 0
    modoEscritura           db "wb", 0
    modoAppend              db "ab", 0

    nombreArchivo           db "partidaGuardada.dat", 0

section .bss

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
    desplazAux          resq 1
    desplazAux2         resq 1

    idArchGuardado      resq 1 ; ID del archivo de la partida guardada
    
    msgErrorEspecificoSold  resb 71 ; Máximo largo de mensaje de error para soldados
    msgErrorEspecificoOfic  resb 71 ; Máximo largo de mensaje de error para oficiales

    msgErrorEspecificoSoldMov   resb 71 ; Máximo largo de mensaje de error para movimientos de soldados
    msgErrorEspecificoOficMov   resb 71 ; Máximo largo de mensaje de error para movimientos de oficiales

    msgCapturaSoldado       resb 38 ; Si se capturó un soldado
    msgOficialRet           resb 59 ; Si se retiró un oficial

section .text
    global main

main:
    ; Vemos si hay una partida guardada
    mOpenFile nombreArchivo, modoLectura
    cmp rax, 0
    jg partidaGuardada
    jmp bienvenida

    partidaGuardada:
        call abrirPartidaGuardada
        cmp byte[turnoDe], 's'
        je loopMovimientos
        jmp turnoOficiales

    bienvenida:
        mPuts msgBienvenida
        
    ; Se debe elegir quién inicia la partida
    personalizarQuienInicia:
        mov dword[piezaIniElegida], ''    ; vaciar variable
        mPuts msgQuienInicia
        mGets piezaIniElegida

        cmp dword[piezaIniElegida], '#'
        je salirSinGuardar

        cmp dword[piezaIniElegida], 'o' 
        je setearPiezaInicio
        cmp dword[piezaIniElegida], 's'
        je setearPiezaInicio

        mErrorJump msgOpcionInvalida, personalizarQuienInicia

        setearPiezaInicio:
            mMov piezaDeInicio, piezaIniElegida, 1
            jmp comenzarPorInicio

; --------------------------------------------------------------------------------------------
; RUTINA PARA COMENZAR EL JUEGO -> Se comienza desde el jugador elegido (o el default)
; --------------------------------------------------------------------------------------------

comenzarPorInicio:
    mMov tableroEnJuego, tableroOrig, 116

    cmp byte[piezaDeInicio], 's'
    je loopMovimientos
    cmp byte[piezaDeInicio], 'o'
    je turnoOficiales


; COMIENZA EL JUEGO
loopMovimientos:; mostrarTablero, mostrarTurno, realizarMovimiento, verificarFinJuego
    ; Limpiamos los mensajes de error
    mov byte[msgErrorEspecificoSold], 0
    mov byte[msgErrorEspecificoSoldMov], 0
    mov byte[msgErrorEspecificoOfic], 0
    mov byte[msgErrorEspecificoOficMov], 0
    mov byte[msgCapturaSoldado], 0
    mov byte[msgOficialRet], 0

    turnoSoldados:
        mov byte[turnoDe], 's'
        mov byte [soldadoElegido], '0'
    
        mCommand cmdLimpiarPantalla ; Limpia la pantalla para mostrar el tablero

        mPuts tableroEnJuego ; Muestro el tablero

        cmp byte[msgErrorEspecificoSold], 0
        jne imprimirErrorSold

        cmp byte[msgErrorEspecificoSoldMov], 0
        jne imprimirErrorSoldMov

        cmp byte[msgErrorEspecificoOficMov], 0
        jne imprimirOficInvalidado

        cmp byte[msgOficialRet], 0
        jne imprimirOficRetirado

        cmp byte[msgCapturaSoldado], 0
        jne imprimirCapturaSoldado

        todoOkSold:
            ; Limpiamos los mensajes de error
            mov byte[msgErrorEspecificoSold], 0
            mov byte[msgErrorEspecificoSoldMov], 0
            mov byte[msgErrorEspecificoOficMov], 0
            mov byte[msgCapturaSoldado], 0
            mov byte[msgOficialRet], 0

            mPuts msgTurnoSoldados      ; Muestra el mensaje de seleccionar ficha a mover
            mGets soldadoElegido        ; Obtiene la ficha a mover

            cmp byte[soldadoElegido], '#'
            je salirDelJuego
            
            jmp verificarFichaSold ; Verifica si la ficha elegida es valida

            casillaAMoverseSold:
                
                mPuts msgTurnoMovSold   ; Muestra el mensaje de seleccionar casilla a mover
                mGets casillaMovSold    ; Obtiene la casilla a mover

                cmp byte[casillaMovSold], '#'
                je salirDelJuego

                jmp verificarMovimientoSold ; Verifica si el movimiento es valido

                moverSoldado:
                    call realizarMovimientoSold ; Realiza el movimiento
                    
                    call verificarFinJuegoSoldados ; Verificar fin de juego por algún movimiento de soldado
                    cmp rax, 0
                    je finDeJuego

    mov byte[msgErrorEspecificoOfic], 0
    turnoOficiales:
        mov byte[turnoDe], 'o'
        mov byte[oficialElegido], '0'
        
        mCommand cmdLimpiarPantalla ; Limpia la pantalla para mostrar el tablero

        mPuts tableroEnJuego ; Muestra el tablero

        cmp byte[msgErrorEspecificoOfic], 0
        jne imprimirErrorOfic

        cmp byte[msgErrorEspecificoOficMov], 0
        jne imprimirOficInvalidado

        todoOkOfic:
            ; Limpiamos los mensajes de error
            mov byte[msgErrorEspecificoOfic], 0
            mov byte[msgErrorEspecificoOficMov], 0

            mPuts msgTurnoOficiales ; Muestra el mensaje de seleccionar ficha a mover
            mGets oficialElegido    ; Obtiene la ficha a mover

            cmp byte[oficialElegido], '#'
            je salirDelJuego

            jmp verificarFichaOfic ; Verifica si la ficha elegida es valida

            casillaAMoverseOfic:

                mPuts msgTurnoMovOfic   ; Muestra el mensaje de seleccionar casilla a mover
                mGets casillaMovOfic    ; Obtiene la casilla a mover

                cmp byte[casillaMovOfic], '#'
                je salirDelJuego
                
                jmp verificarMovimientoOfic ; Verifica si el movimiento es valido

                moverOficial:
                    call realizarMovimientoOfic ; Realiza el movimiento
                    ; Verificar fin de juego por algún movimiento de oficial
                    call verificarFinJuegoOficiales
                    cmp rax, 0
                    je finDeJuego
                    
                    jmp turnoSoldados
                
                capturar:
                    call capturarSoldado ; Captura soldado
                    ; Verificar fin de juego por captura de soldado
                    call verificarFinJuegoOficiales
                    cmp rax, 0
                    je finDeJuego
                    
                ; Repetir en loop
                jmp turnoSoldados

    ret

; --------------------------------------------------------------------------------------------
; VERIFICACIONES DE PIEZAS ORIGINALES A MOVER PARA SOLDADOS Y OFICIALES
; --------------------------------------------------------------------------------------------

verificarFichaSold:
    mov al, byte[soldadoElegido] ; Numero de fila
    
    ; Compromabos que el caracter ingresado sea un número entre 1 y 7
    cmp al, '1'
    jl errorInputSold
    cmp al, '7'
    jg errorInputSold

    ; Parseamos el número de fila de string a int
    mov qword[fila], 0
    mSscanf byte[soldadoElegido], formatoAtoi, fila
    cmp rax, 1
    jl errorInputSold

    ; Comprobamos que el caracter siguiente sea un guión para que cumpla con el formato establecido
    mov al, byte[soldadoElegido+1] ; Caracter '-'
    cmp al, '-'
    jne errorInputSold
    
    ; Comprobamos que el número de columna sea un número entre 1 y 7
    mov al, byte[soldadoElegido+2] ; Numero de columna
    cmp al, '1'
    jl errorInputSold
    cmp al, '7'
    jg errorInputSold

    ; Parseamos el número de columna de string a int
    mov qword[columna], 0
    mSscanf byte[soldadoElegido+2], formatoAtoi, columna
    cmp rax, 1
    jl errorInputSold

    ; El ultimo caracter del string ingresado debe ser un caracter nulo
    mov al, byte[soldadoElegido+3] ; Caracter nulo
    cmp al, 0
    jne errorInputSold

    ; Calculamos desplazamiento en el tablero
    ;  mCalcDesplaz calcula el desplazamiento en el tablero en base a la fila y columna y lo almacena en desplazCasOrig usando una formula
    mCalcDesplaz [fila], [columna], qword[desplazCasOrig]
    mov rbx, qword[desplazCasOrig]
    
    ; Limpio los registros
    mov rax,0
    mov rdx, 0

    ; Cargo en dl el caracter de la casilla en el tablero y en al el simbolo de los soldados
    mov dl, byte[tableroEnJuego+rbx]
    mov al, [simboloSoldados]

    ; Comparo los caracteres, deben ser iguales para que el movimiento no sea invalido
    cmp dl, al
    jne errorCasillaInvalidaSold
    
    ; Si no hubo errores, limpio el mensaje de error y sigo con la ejecucion
    mov rax, 0
    mov [msgErrorEspecificoSold], rax
    jmp casillaAMoverseSold

    ; Errores
    errorInputSold:
        mov rax, [msgErrorInputSold]
        mMov msgErrorEspecificoSold, msgErrorInputSold, 62
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
    
    ; Compromabos que el caracter ingresado para la fila sea un número entre 1 y 7
    cmp cl, '1'
    jl errorInputOfic
    cmp cl, '7'
    jg errorInputOfic
    
    ; Parseamos el número de fila de string a int
    mov qword[fila], 0
    mSscanf byte[oficialElegido], formatoAtoi, fila
    cmp rax, 1
    jl errorInputOfic

    ; Comprobamos que el caracter siguiente sea un guión para que cumpla con el formato establecido
    mov cl, byte[oficialElegido+1] ; Caracter '-'
    cmp cl, '-'
    jne errorInputOfic
    
    ; Comprobamos que el número de columna sea un número entre 1 y 7
    mov cl, byte[oficialElegido+2] ; Numero de columna
    cmp cl, '1'
    jl errorInputOfic
    cmp cl, '7'
    jg errorInputOfic

    ; Parseamos el número de columna de string a int
    mov qword[columna], 0
    mSscanf byte[oficialElegido+2], formatoAtoi, columna
    cmp rax, 1
    jl errorInputOfic

    ; El ultimo caracter del string ingresado debe ser un caracter nulo
    mov cl, byte[oficialElegido+3] ; Caracter nulo
    cmp cl, 0
    jne errorInputOfic

    ; Calculamos desplazamiento en tablero
    ; mCalcDesplaz calcula el desplazamiento en el tablero en base a la fila y columna y lo almacena en desplazCasOrig usando una formula
    mCalcDesplaz [fila], [columna], qword[desplazCasOrig]
    mov rbx, qword[desplazCasOrig]
    
    ; Limpio los registros
    mov rax, 0
    mov rdx, 0

    ; Cargo en dl el caracter de la casilla en el tablero y en cl el simbolo de los oficiales
    mov dl, byte[tableroEnJuego+rbx]
    mov cl, [simboloOficiales]

    ; Comparo los caracteres, deben ser iguales para que el movimiento no sea invalido
    cmp dl, cl
    jne errorCasillaInvalidaOfic

    ; Si no hubo errores, limpio el mensaje de error y sigo con la ejecucion
    mov rax, 0
    mov [msgErrorEspecificoOfic], rax
    jmp casillaAMoverseOfic

    ; Errores
    errorInputOfic:
        mov rax, [msgErrorInputOfic]
        mMov msgErrorEspecificoOfic, msgErrorInputOfic, 62
        jmp turnoOficiales

    errorCasillaInvalidaOfic:
        mov rax, [msgCasillaInvalidaOfic]
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
    
    ; Compromabos que el caracter ingresado sea un número entre 1 y 7
    cmp al, '1'
    jl errorInputSoldMov
    cmp al, '7'
    jg errorInputSoldMov

    ; Parseamos el número de fila de string a int
    mov qword[filaAMover], 0
    mSscanf byte[casillaMovSold], formatoAtoi, filaAMover
    cmp rax, 1
    jl errorInputSoldMov

    ; Comprobamos que el caracter siguiente sea un guión para que cumpla con el formato establecido
    mov al, byte[casillaMovSold+1] ; Caracter '-'
    cmp al, '-'
    jne errorInputSoldMov
    
    ; Comprobamos que el número de columna sea un número entre 1 y 7
    mov al, byte[casillaMovSold+2] ; Numero de columna
    cmp al, '1'
    jl errorInputSoldMov
    cmp al, '7'
    jg errorInputSoldMov
    
    ; Parseamos el número de columna de string a int
    mov qword[columnaAMover], 0
    mSscanf byte[casillaMovSold+2], formatoAtoi, columnaAMover
    cmp rax, 1
    jl errorInputSoldMov

    ; El ultimo caracter del string ingresado debe ser un caracter nulo
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
        ; Comparamos la fila a mover con la fila actual, la fila a mover debe ser igual a la fila actual + 1
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

    ; Errores
    errorInputSoldMov:
        mov rax, [msgErrorInputSold]
        mMov msgErrorEspecificoSoldMov, msgErrorInputSold, 62
        jmp turnoSoldados

    errorCasillaInvalidaSoldMov:
        mov rax, [msgCasillaInvMovSold]
        mMov msgErrorEspecificoSoldMov, msgCasillaInvMovSold, 62
        jmp turnoSoldados

    imprimirErrorSoldMov:
        mPuts msgErrorEspecificoSoldMov
        jmp todoOkSold

    ; Si la casilla original es una casilla especial, solo podemos movernos a la derecha o a la izquierda
    soloDerechaSold:
        mov r8, 1 ; Suponemos que el movimiento es inválido

        mCalcDesplaz [filaAMover], [columnaAMover], qword[desplazCasAMover] ; Calculamos el desplazamiento de la casilla a mover
        mEstaVacia qword[desplazCasAMover] ; Verificamos si la casilla a mover está vacía
        cmp rax, 1 ; Si recibimos 1, la casilla a mover está ocupada (o está fuera del tablero)
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
        mHaySoldado qword[desplazCasAMover]
        cmp rax, 1
        je errorCasillaInvalidaOficMov ; Si recibimos 1, la casilla a ocupar no tiene un soldado -> movimiento inválido

        ; Si llegamos acá, la casilla a ocupar tiene un soldado: debemos ver si el oficial puede saltar sobre él...
        call sePuedeSaltarSoldado
        cmp rax, 1
        je errorCasillaInvalidaOficMov ; Si recibimos 1, el oficial no puede saltar sobre el soldado -> movimiento inválido

        mMov msgCapturaSoldado, msgCapturaSold, 38
        jmp capturar

    errorInputOficMov:
        mov rax, [msgErrorInputOfic]
        mMov msgErrorEspecificoOficMov, msgErrorInputOfic, 62
        jmp turnoOficiales

    errorCasillaInvalidaOficMov:
        mov rax, [msgCasillaInvMovOfic]
        mMov msgErrorEspecificoOficMov, msgCasillaInvMovOfic, 62
        jmp turnoOficiales

    imprimirErrorOficMov:
        mPuts msgErrorEspecificoOficMov
        jmp todoOkOfic

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
; RUTINA PARA VERIFICAR SI HAY UN SOLDADO EN LA CASILLA DESTINO
; --------------------------------------------------------------------------------------------

haySoldado:
    ; Calculamos desplazamiento en tablero
    mCmp byte[tableroEnJuego+rdi], [simboloSoldados], 1
    je okSoldado

    mov rax, 1
    ret

    okSoldado:
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

; --------------------------------------------------------------------------------------------------
; RUTINAS PARA REALIZAR MOVIMIENTOS SIMPLES DE SOLDADOS Y OFICIALES (los que no requieren capturas)
; --------------------------------------------------------------------------------------------------

realizarMovimientoSold:
    mov rax, qword[desplazCasOrig]
    mov rbx, qword[desplazCasAMover]

    mov byte[tableroEnJuego+rax], ' '
    mMov tableroEnJuego+rbx, simboloSoldados, 1

    ret

realizarMovimientoOfic:
    ; Vemos si el oficial podía capturar un soldado y no lo hizo
    mMov desplazAux2, desplazCasOrig, 1
    call podiaCapturarSoldado 
    cmp rax, 0 ; Si fue así, significa que el oficial se desentendió de su deber
    je quitarOficial

    ; Necesitamos chequear si el otro oficial podría haber capturado al soldado
    call podiaCapturarSoldadoOtroOficial
    cmp rax, 0 ; Si fue así, significa que el otro oficial se desentendió de su deber
    je quitarOtroOficial

    jmp noPodianCapturar

    imprimirOficInvalidado:
        mPuts msgErrorEspecificoOficMov
        jmp todoOkOfic

    imprimirOficRetirado:
        mPuts msgOficialRet
        jmp todoOkSold

    quitarOficial:
        call verQueOficialEs
        cmp rax, 1 ; Si recibimos 1, el oficial 1 es el que se mueve
        je quitarOfic1

        ; Si llegamos acá, el oficial 2 es el que se mueve
        mCalcDesplaz [casillaOfic2], [casillaOfic2+8], qword[desplazAux]
        call desentenderOficial
        mMov msgOficialRet, msgOficialRetirado, 59
        ret

        quitarOfic1:
            mCalcDesplaz [casillaOfic1], [casillaOfic1+8], qword[desplazAux]
            call desentenderOficial
            mMov msgOficialRet, msgOficialRetirado, 59
            ret
    
    quitarOtroOficial:
        call desentenderOtroOficial
        mMov msgOficialRet, msgOficialRetirado, 59
        ret

    ; Si llegamos acá, el oficial no podía capturar un soldado -> OK!
    noPodianCapturar:
        mov rax, qword[desplazCasOrig]
        mov rbx, qword[desplazCasAMover]

        mov byte[tableroEnJuego+rax], ' '
        mMov tableroEnJuego+rbx, simboloOficiales, 1

        call verQueOficialEs ; Verificamos qué oficial es el que se quiere mover

        ; Incrementamos la cantidad de movimientos del oficial correspondiente
        cmp rax, 1 ; Si recibimos 1, el oficial 1 es el que se mueve
        je movOfic1
            
        ; Si llegamos acá, el oficial 2 es el que se mueve
        call actualizarContadoresOfic2
        call refrescarCasActOfic2
        ret
    
    movOfic1: ; Si llegamos acá, el oficial 1 es el que se mueve
        call actualizarContadoresOfic1
        call refrescarCasActOfic1

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

        ; Salto hacia arriba y a la derecha
        inc qword[columnaAux] 
        jmp seguirSaltoArriba

        ; Salto hacia arriba y a la izquierda
        haciaArribaIzq:
            dec qword[columnaAux] 

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

        ; Salto hacia abajo y a la derecha
        inc qword[columnaAux] 
        jmp seguirSaltoAbajo

        ; Salto hacia abajo y a la izquierda
        haciaAbajoIzq:
            dec qword[columnaAux] 

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

    call verQueOficialEs ; Verificamos qué oficial es el que se quiere mover

    cmp rax, 1
    je movOfic1Captura

    inc qword[cantCapturasOfic2]
    call actualizarContadoresOfic2
    call refrescarCasActOficLuegoCaptura
    mMov msgCapturaSoldado, msgCapturaSold, 38
    ret

    imprimirCapturaSoldado:
        mPuts msgCapturaSoldado 
        jmp todoOkSold

    movOfic1Captura:
        inc qword[cantCapturasOfic1]
        call actualizarContadoresOfic1
        call refrescarCasActOficLuegoCaptura
        mMov msgCapturaSoldado, msgCapturaSold, 38

    ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR CUÁL OFICIAL SE ESTÁ MOVIENDO
; --------------------------------------------------------------------------------------------

verQueOficialEs:
    ; Comenzamos verificando si el oficial 1 es el que se está moviendo
    mCmp qword[fila], qword[casillaOfic1], 1 ; Fila de la casilla de origen vs. Fila del oficial 1
    jne esOfic2 ; Si las filas no son iguales, el oficial 1 no es el que se está moviendo
    mCmp qword[columna], qword[casillaOfic1+8], 1 ; Columna de la casilla de origen vs. Columna del oficial 1
    jne esOfic2 ; Si las columnas no son iguales, el oficial 1 no es el que se está moviendo

    mov rax, 1 ; es el oficial 1
    ret

    esOfic2:
        mov rax, 2 ; es el oficial 2

    ret


; --------------------------------------------------------------------------------------------
; RUTINA PARA ACTUALIZAR LOS CONTADORES DE MOVIMIENTOS DE LOS OFICIALES
; --------------------------------------------------------------------------------------------

actualizarContadoresOfic1:
    inc qword[movimientosOfic1]
    mov rax, qword[desplazCasOrig]
    sub rax, qword[desplazCasAMover] ; rax = desplazOrigen - desplazDestino
    cmp rax, 1
    je movOfic1Izq
    cmp rax, -1
    je movOfic1Der
    cmp rax, 11
    je movOfic1Arriba
    cmp rax, -11
    je movOfic1Abajo
    cmp rax, 10
    je movOfic1ArrDer
    cmp rax, -10
    je movOfic1AbjIzq
    cmp rax, 12
    je movOfic1ArrIzq
    cmp rax, -12
    je movOfic1AbjDer

    ret

    movOfic1Izq:
        inc qword[movOfic1Izquierda]
        ret
    movOfic1Der:
        inc qword[movOfic1Derecha]
        ret
    movOfic1Arriba:
        inc qword[movOfic1Adelante]
        ret
    movOfic1Abajo:
        inc qword[movOfic1Atras]
        ret
    movOfic1ArrDer:
        inc qword[movOfic1Diagonal]
        inc qword[movOfic1DiagArribaDer]
        ret
    movOfic1AbjDer:
        inc qword[movOfic1Diagonal]
        inc qword[movOfic1DiagAbajoDer]
        ret
    movOfic1AbjIzq:
        inc qword[movOfic1Diagonal]
        inc qword[movOfic1DiagAbajoIzq]
        ret
    movOfic1ArrIzq:
        inc qword[movOfic1Diagonal]
        inc qword[movOfic1DiagArribaIzq]
        ret

actualizarContadoresOfic2:
    inc qword[movimientosOfic2]
    mov rax, qword[desplazCasOrig]
    sub rax, qword[desplazCasAMover] ; rax = desplazOrigen - desplazDestino
    cmp rax, 1
    je movOfic2Izq
    cmp rax, -1
    je movOfic2Der
    cmp rax, 11
    je movOfic2Arriba
    cmp rax, -11
    je movOfic2Abajo
    cmp rax, 10
    je movOfic2ArrDer
    cmp rax, -10
    je movOfic2AbjIzq
    cmp rax, 12
    je movOfic2ArrIzq
    cmp rax, -12
    je movOfic2AbjDer

    ret

    movOfic2Izq:
        inc qword[movOfic2Izquierda]
        ret
    movOfic2Der:
        inc qword[movOfic2Derecha]
        ret
    movOfic2Arriba:
        inc qword[movOfic2Adelante]
        ret
    movOfic2Abajo:
        inc qword[movOfic2Atras]
        ret
    movOfic2ArrDer:
        inc qword[movOfic2Diagonal]
        inc qword[movOfic2DiagArribaDer]
        ret
    movOfic2AbjDer:
        inc qword[movOfic2Diagonal]
        inc qword[movOfic2DiagAbajoDer]
        ret
    movOfic2AbjIzq:
        inc qword[movOfic2Diagonal]
        inc qword[movOfic2DiagAbajoIzq]
        ret
    movOfic2ArrIzq:
        inc qword[movOfic2Diagonal]
        inc qword[movOfic2DiagArribaIzq]
        ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA REFRESCAR LA CASILLA ACTUAL DE LOS OFICIALES
; --------------------------------------------------------------------------------------------

refrescarCasActOfic1:
    mMov casillaOfic1, filaAMover, 1
    mMov casillaOfic1+8, columnaAMover, 1
    ret

refrescarCasActOfic2:
    mMov casillaOfic2, filaAMover, 1
    mMov casillaOfic2+8, columnaAMover, 1
    ret    

refrescarCasActOficLuegoCaptura:
    mov rax, qword[desplazCasAMover]
    mov rbx, qword[desplazAux]
    sub rax, rbx ; rax = desplazCasAMover - desplazAux

    cmp rax, 1
    je saltoIzq
    cmp rax, -1
    je saltoDer
    cmp rax, 11
    je saltoArriba
    cmp rax, -11
    je saltoAbajo
    cmp rax, 10
    je saltoArrDer
    cmp rax, -10
    je saltoAbjIzq
    cmp rax, 12
    je saltoArrIzq
    cmp rax, -12
    je saltoAbjDer

    saltoIzq:
        dec qword[columnaAMover]
        jmp finRefrescarCasActOfic
    saltoDer:
        inc qword[columnaAMover]
        jmp finRefrescarCasActOfic
    saltoArriba:
        dec qword[filaAMover]
        jmp finRefrescarCasActOfic
    saltoAbajo:
        inc qword[filaAMover]
        jmp finRefrescarCasActOfic
    saltoArrDer:
        dec qword[filaAMover]
        inc qword[columnaAMover]
        jmp finRefrescarCasActOfic
    saltoAbjIzq:
        inc qword[filaAMover]
        dec qword[columnaAMover]
        jmp finRefrescarCasActOfic
    saltoArrIzq:
        dec qword[filaAMover]
        dec qword[columnaAMover]
        jmp finRefrescarCasActOfic
    saltoAbjDer:
        inc qword[filaAMover]
        inc qword[columnaAMover]

    finRefrescarCasActOfic:
        call verQueOficialEs

        cmp rax, 1
        je actualizarOfic1

        call refrescarCasActOfic2
        ret

        actualizarOfic1:
            call refrescarCasActOfic1

    ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR SI UN OFICIAL PODÍA CAPTURAR UN SOLDADO Y NO LO HIZO
; --------------------------------------------------------------------------------------------

podiaCapturarSoldado:
    mMov desplazAux, desplazAux2, 1

    ; Casilla arriba-izquierda
    sub qword[desplazAux], 12
    mHaySoldado qword[desplazAux]
    cmp rax, 0
    jne verCasArriba

    mPuedeCapturar 12, 1 ; restar 12 a desplazAux
    cmp rax, 0
    je podiaCapturar

    ; Casilla arriba
    verCasArriba:
        mMov desplazAux, desplazAux2, 1
        sub qword[desplazAux], 11
        mHaySoldado qword[desplazAux]
        cmp rax, 0
        jne verCasArribaDer

        mPuedeCapturar 11, 1 ; restar 11 a desplazAux
        cmp rax, 0
        je podiaCapturar

    ; Casilla arriba-derecha
    verCasArribaDer:
        mMov desplazAux, desplazAux2, 1
        sub qword[desplazAux], 10
        mHaySoldado qword[desplazAux]
        cmp rax, 0
        jne verCasIzq
        
        mPuedeCapturar 10, 1 ; restar 10 a desplazAux
        cmp rax, 0
        je podiaCapturar

    ; Casilla izquierda
    verCasIzq:
        mMov desplazAux, desplazAux2, 1
        sub qword[desplazAux], 1
        mHaySoldado qword[desplazAux]
        cmp rax, 0
        jne verCasDer
        
        mPuedeCapturar 1, 1 ; restar 1 a desplazAux
        cmp rax, 0
        je podiaCapturar

    ; Casilla derecha
    verCasDer:
        mMov desplazAux, desplazAux2, 1
        add qword[desplazAux], 1
        mHaySoldado qword[desplazAux]
        cmp rax, 0
        jne verCasAbajoIzq
        
        mPuedeCapturar 1, 0 ; sumar 1 a desplazAux
        cmp rax, 0
        je podiaCapturar

    ; Casilla abajo-izquierda
    verCasAbajoIzq:
        mMov desplazAux, desplazAux2, 1
        add qword[desplazAux], 10
        mHaySoldado qword[desplazAux]
        cmp rax, 0
        jne verCasAbajo
        
        mPuedeCapturar 10, 0 ; sumar 10 a desplazAux
        cmp rax, 0
        je podiaCapturar

    ; Casilla abajo
    verCasAbajo:
        mMov desplazAux, desplazAux2, 1
        add qword[desplazAux], 11
        mHaySoldado qword[desplazAux]
        cmp rax, 0
        jne verCasAbajoDer
        
        mPuedeCapturar 11, 0 ; sumar 11 a desplazAux
        cmp rax, 0
        je podiaCapturar

    ; Casilla abajo-derecha
    verCasAbajoDer:
        mMov desplazAux, desplazAux2, 1
        add qword[desplazAux], 12
        mHaySoldado qword[desplazAux]
        cmp rax, 0
        jne okNoPodiaCapturar
        
        mPuedeCapturar 12, 0 ; sumar 12 a desplazAux
        cmp rax, 0
        je podiaCapturar
    
    okNoPodiaCapturar:
        mov rax, 1
        ret
    
    podiaCapturar:
        mov rax, 0

    ret

podiaComerPieza:
    cmp rsi, 0 ; 0 para sumar, 1 para restar
    je sumarDesplaz 

    ; Si llegamos acá, debemos restar
    sub qword[desplazAux], rdi
    jmp verSiEspacioEstaLibre

    sumarDesplaz:
        add qword[desplazAux], rdi

    verSiEspacioEstaLibre:
        mEstaVacia qword[desplazAux]
        cmp rax, 0
        je okComerPieza

        mov rax, 1
        ret

    okComerPieza:
        mov rax, 0
        ret

    
; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR SI EL OTRO OFICIAL PODÍA CAPTURAR UN SOLDADO Y NO LO HIZO
; --------------------------------------------------------------------------------------------

podiaCapturarSoldadoOtroOficial:
    call verQueOficialEs ; Verificamos qué oficial es el que se quiere mover
    cmp rax, 1
    je verificarOfic2

    verificarOfic1:
        mCalcDesplaz qword[casillaOfic1], qword[casillaOfic1+8], qword[desplazAux2]
        call podiaCapturarSoldado
        cmp rax, 0
        je okPodiaComerElOtro
        jmp noPodiaComerElOtro
    
    verificarOfic2:
        mCalcDesplaz qword[casillaOfic2], qword[casillaOfic2+8], qword[desplazAux2]
        call podiaCapturarSoldado
        cmp rax, 0
        je okPodiaComerElOtro
        jmp noPodiaComerElOtro

    okPodiaComerElOtro:
        mov rax, 0
        ret

    noPodiaComerElOtro:
        mov rax, 1

    ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA QUITAR AL OFICIAL QUE SE MOVIÓ Y NO CAPTURÓ UN SOLDADO
; --------------------------------------------------------------------------------------------

desentenderOficial:
    mov rbx, qword[desplazAux]
    mov rdx, ' '
    mov byte[tableroEnJuego+rbx], dl

    call verQueOficialEs ; Verificamos qué oficial es el que se quiere mover

    cmp rax, 1
    je desentenderOfic1

    desentenderOfic2:
        mov qword[casillaOfic2], 0
        mov qword[casillaOfic2+8], 0
        jmp agregarOficDesentendido

    desentenderOfic1:
        mov qword[casillaOfic1], 0
        mov qword[casillaOfic1+8], 0

    agregarOficDesentendido:
        inc qword[cantOficInvalidados]
    
    ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA QUITAR AL OTRO OFICIAL QUE NO CAPTURÓ UN SOLDADO
; --------------------------------------------------------------------------------------------

desentenderOtroOficial:
    call verQueOficialEs ; Verificamos qué oficial es el que se quiere mover

    cmp rax, 1
    je otroEsOfic2

    otroEsOfic1:
        mCalcDesplaz qword[casillaOfic1], qword[casillaOfic1+8], qword[desplazAux]

        ; Vacía la casilla del oficial 1
        mov rbx, qword[desplazAux]
        mov rdx, ' '
        mov byte[tableroEnJuego+rbx], dl

        ; Actualiza las variables del oficial 1
        mov qword[casillaOfic1], 0
        mov qword[casillaOfic1+8], 0

        call agregarOficDesentendido
        ret

    otroEsOfic2:
        mCalcDesplaz qword[casillaOfic2], qword[casillaOfic2+8], qword[desplazAux]
        
        ; Vacía la casilla del oficial 2
        mov rbx, qword[desplazAux]
        mov rdx, ' '
        mov byte[tableroEnJuego+rbx], dl

        ; Actualiza las variables del oficial 2
        mov qword[casillaOfic2], 0
        mov qword[casillaOfic2+8], 0
    
        call agregarOficDesentendido
        ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA VER SI EL MOVIMIENTO DE UN OFICIAL RESULTA EN EL FIN DEL JUEGO
; --------------------------------------------------------------------------------------------

verificarFinJuegoOficiales:
    ; Verificamos si ambos oficiales han sido invalidados
    cmp qword[cantOficInvalidados], 2
    je finInvalidados

    ; Verificamos que los oficiales hayan capturado necesarios soldados para ganar
    cmp qword[cantSoldCapturados], 16
    je finSoldCapturados

    mov rax, 1
    ret

    finInvalidados:
        mov dword[varRazonFin], "oInv"
        jmp hayFinJuegoOfic

    finSoldCapturados:
        mov dword[varRazonFin], "sCap"

    hayFinJuegoOfic:
        mov rax, 0
        ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR SI EL MOVIMIENTO DE UN SOLDADO RESULTA EN EL FIN DEL JUEGO
; --------------------------------------------------------------------------------------------

verificarFinJuegoSoldados:
    call soldadosOcupanFortaleza
    cmp rax, 0
    je finOcupFortaleza

    call oficialesRodeados
    cmp rax, 0
    je finOficRodeados

    mov rax, 1
    ret

    finOcupFortaleza:
        mov dword[varRazonFin], "sOcu"
        jmp hayFinJuegoSold

    finOficRodeados:
        mov dword[varRazonFin], "oRod"

    hayFinJuegoSold:
        mov rax, 0
        ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR SI LOS SOLDADOS OCUPAN LA FORTALEZA
; --------------------------------------------------------------------------------------------

soldadosOcupanFortaleza:
    mCmp byte[tableroEnJuego+70], [simboloSoldados], 1 ; Fortaleza 1-1
    jne noOcupaFortaleza
    mCmp byte[tableroEnJuego+71], [simboloSoldados], 1 ; Fortaleza 1-2
    jne noOcupaFortaleza
    mCmp byte[tableroEnJuego+72], [simboloSoldados], 1 ; Fortaleza 1-3
    jne noOcupaFortaleza
    mCmp byte[tableroEnJuego+81], [simboloSoldados], 1 ; Fortaleza 2-1
    jne noOcupaFortaleza
    mCmp byte[tableroEnJuego+82], [simboloSoldados], 1 ; Fortaleza 2-2
    jne noOcupaFortaleza
    mCmp byte[tableroEnJuego+83], [simboloSoldados], 1 ; Fortaleza 2-3
    jne noOcupaFortaleza
    mCmp byte[tableroEnJuego+92], [simboloSoldados], 1 ; Fortaleza 3-1
    jne noOcupaFortaleza
    mCmp byte[tableroEnJuego+93], [simboloSoldados], 1 ; Fortaleza 3-2
    jne noOcupaFortaleza
    mCmp byte[tableroEnJuego+94], [simboloSoldados], 1 ; Fortaleza 3-3
    jne noOcupaFortaleza

    mov rax, 0
    ret

    noOcupaFortaleza:
        mov rax, 1

    ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA VERIFICAR SI LOS OFICIALES ESTÁN RODEADOS POR SOLDADOS
; --------------------------------------------------------------------------------------------

oficialesRodeados:
    call ofic1Desentendido
    cmp rax, 0
    je rodeanAOfic2
    call verSiOfic1Rodeado
    cmp rax, 0
    jne tienenSalida

    rodeanAOfic2:
        call ofic2Desentendido
        cmp rax, 0
        je noHaySalida
        call verSiOfic2Rodeado
        cmp rax, 0
        jne tienenSalida

    noHaySalida:
        mov rax, 0
        ret

    tienenSalida:
        mov rax, 1

    ret

verSiOfic1Rodeado:
    mCalcDesplaz qword[casillaOfic1], qword[casillaOfic1+8], qword[desplazAux]
    mMov desplazAux2, desplazAux, 1
    call verSiOficialRodeado
    ret

verSiOfic2Rodeado:
    mCalcDesplaz qword[casillaOfic2], qword[casillaOfic2+8], qword[desplazAux]
    mMov desplazAux2, desplazAux, 1
    call verSiOficialRodeado
    ret

verSiOficialRodeado:
    ; Casilla arriba-izquierda
    sub qword[desplazAux], 12
    mEstaVacia qword[desplazAux]
    cmp rax, 0 ; Si el oficial tiene una casilla vacía, puede moverse -> no está rodeado 
    je okPuedeMoverse
    mHaySoldado qword[desplazAux]
    cmp rax, 1 ; Si no hay soldado, significa que es un límite del tablero -> me fijo en otra casilla
    je verEspacioArr
    mPuedeCapturar 12, 1 ; restar 12 a desplazAux
    cmp rax, 0 ; Si el oficial puede capturar un soldado, no está rodeado
    je okPuedeMoverse

    ; Casilla arriba
    verEspacioArr: 
        mMov desplazAux, desplazAux2, 1
        sub qword[desplazAux], 11
        mEstaVacia qword[desplazAux]
        cmp rax, 0  
        je okPuedeMoverse
        mHaySoldado qword[desplazAux]
        cmp rax, 1
        je verEspacioArrDer
        mPuedeCapturar 11, 1 ; restar 11 a desplazAux
        cmp rax, 0
        je okPuedeMoverse

    ; Casilla arriba-derecha
    verEspacioArrDer:
        mMov desplazAux, desplazAux2, 1
        sub qword[desplazAux], 10
        mEstaVacia qword[desplazAux]
        cmp rax, 0  
        je okPuedeMoverse
        mHaySoldado qword[desplazAux]
        cmp rax, 1
        je verEspacioIzq
        mPuedeCapturar 10, 1 ; restar 10 a desplazAux
        cmp rax, 0
        je okPuedeMoverse

    ; Casilla izquierda
    verEspacioIzq:
        mMov desplazAux, desplazAux2, 1
        sub qword[desplazAux], 1
        mEstaVacia qword[desplazAux]
        cmp rax, 0  
        je okPuedeMoverse
        mHaySoldado qword[desplazAux]
        cmp rax, 1
        je verEspacioDer
        mPuedeCapturar 1, 1 ; restar 1 a desplazAux 
        cmp rax, 0
        je okPuedeMoverse

    ; Casilla derecha
    verEspacioDer:
        mMov desplazAux, desplazAux2, 1
        add qword[desplazAux], 1
        mEstaVacia qword[desplazAux]
        cmp rax, 0  
        je okPuedeMoverse
        mHaySoldado qword[desplazAux]
        cmp rax, 1
        je verEspacioAbjIzq
        mPuedeCapturar 1, 0 ; sumar 1 a desplazAux 
        cmp rax, 0
        je okPuedeMoverse

    ; Casilla abajo-izquierda
    verEspacioAbjIzq:
        mMov desplazAux, desplazAux2, 1
        add qword[desplazAux], 10
        mEstaVacia qword[desplazAux]
        cmp rax, 0  
        je okPuedeMoverse
        mHaySoldado qword[desplazAux]
        cmp rax, 1
        je verEspacioAbajo
        mPuedeCapturar 10, 0 ; sumar 10 a desplazAux 
        cmp rax, 0
        je okPuedeMoverse

    ; Casilla abajo
    verEspacioAbajo:
        mMov desplazAux, desplazAux2, 1
        add qword[desplazAux], 11
        mEstaVacia qword[desplazAux]
        cmp rax, 0  
        je okPuedeMoverse
        mHaySoldado qword[desplazAux]
        cmp rax, 1
        je verEspacioAbjDer
        mPuedeCapturar 11, 0 ; sumar 11 a desplazAux
        cmp rax, 0
        je okPuedeMoverse

    ; Casilla abajo-derecha
    verEspacioAbjDer:
        mMov desplazAux, desplazAux2, 1
        add qword[desplazAux], 12
        mEstaVacia qword[desplazAux]
        cmp rax, 0  
        je okPuedeMoverse
        mHaySoldado qword[desplazAux]
        cmp rax, 1
        je noPuedeMoverse
        mPuedeCapturar 12, 0 ; sumar 12 a desplazAux
        cmp rax, 0
        je okPuedeMoverse

    ; Si llegamos acá, el oficial está rodeado -> no puede realizar ningún movimiento
    noPuedeMoverse:
        mov rax, 0
        ret

    ; Si llegamos acá, el oficial puede moverse
    okPuedeMoverse:
        mov rax, 1
        ret

ofic1Desentendido:
    cmp qword[casillaOfic1], 0
    je el1EstaDesentendido

    mov rax, 1
    ret

    el1EstaDesentendido:
        mov rax, 0
        ret

ofic2Desentendido:
    cmp qword[casillaOfic2], 0
    je el2EstaDesentendido

    mov rax, 1
    ret

    el2EstaDesentendido:
        mov rax, 0
        ret

; --------------------------------------------------------------------------------------------
; RUTINAS PARA TERMINAR EL JUEGO Y MOSTRAR LAS ESTADÍSTICAS
; --------------------------------------------------------------------------------------------

finDeJuego:
    mCommand cmdBorrarArchivoPartida
    mCommand cmdLimpiarPantalla
    mPuts msgJuegoTerminado

    cmp dword[varRazonFin], "sOcu"
    je soldadosFortaleza

    cmp dword[varRazonFin], "oRod"
    je soldadosRodeanOficiales

    cmp dword[varRazonFin], "oInv"
    je oficialesInvalidados

    cmp dword[varRazonFin], "sCap"
    je soldadosCapturados

    ret

    soldadosFortaleza:
        mPrint msgGanador, stringSoldados
        mPrint msgRazonGanador, msgSoldadosFortaleza
        jmp mostrarEstadisticas

    soldadosRodeanOficiales:
        mPrint msgGanador, stringSoldados
        mPrint msgRazonGanador, msgSoldadosRodean
        jmp mostrarEstadisticas

    oficialesInvalidados:
        mPrint msgGanador, stringSoldados
        mPrint msgRazonGanador, msgSoldadosInvalidar
        jmp mostrarEstadisticas

    soldadosCapturados:
        mPrint msgGanador, stringOficiales
        mPrint msgRazonGanador, msgOficialesGanan
        jmp mostrarEstadisticas

mostrarEstadisticas:
    mPuts msgEstadisticas

    mPrint msgCantTotalCapturas, qword[cantSoldCapturados]

    ; Estadísticas del oficial 1
    mPuts msgOficial1
    mPrint msgCantMovimientos, qword[movimientosOfic1]
    mPrint msgCantAdelante, qword[movOfic1Adelante]
    mPrint msgCantDerecha, qword[movOfic1Derecha]
    mPrint msgCantIzquierda, qword[movOfic1Izquierda]
    mPrint msgCantAtras, qword[movOfic1Atras]
    mPrint msgCantDiagonal, qword[movOfic1Diagonal]
    mPrint msgCantDiagArribaDer, qword[movOfic1DiagArribaDer]
    mPrint msgCantDiagArribaIzq, qword[movOfic1DiagArribaIzq]
    mPrint msgCantDiagAbajoDer, qword[movOfic1DiagAbajoDer]
    mPrint msgCantDiagAbajoIzq, qword[movOfic1DiagAbajoIzq]
    mPrint msgCantSoldadosCapt, qword[cantCapturasOfic1]

    ; Estadísticas del oficial 2
    mPuts msgOficial2
    mPrint msgCantMovimientos, qword[movimientosOfic2]
    mPrint msgCantAdelante, qword[movOfic2Adelante]
    mPrint msgCantDerecha, qword[movOfic2Derecha]
    mPrint msgCantIzquierda, qword[movOfic2Izquierda]
    mPrint msgCantAtras, qword[movOfic2Atras]
    mPrint msgCantDiagonal, qword[movOfic2Diagonal]
    mPrint msgCantDiagArribaDer, qword[movOfic2DiagArribaDer]
    mPrint msgCantDiagArribaIzq, qword[movOfic2DiagArribaIzq]
    mPrint msgCantDiagAbajoDer, qword[movOfic2DiagAbajoDer]
    mPrint msgCantDiagAbajoIzq, qword[movOfic2DiagAbajoIzq]
    mPrint msgCantSoldadosCapt, qword[cantCapturasOfic2]

    jmp salirSinGuardar

; --------------------------------------------------------------------------------------------
; RUTINAS PARA SALIR DEL JUEGO (guardando o no la partida)
; --------------------------------------------------------------------------------------------

salirSinGuardar:
    mov rax, 0
    ret

salirDelJuego:
    mCommand cmdLimpiarPantalla

    mPuts msgSalidaPartida
    mPuts msgAclaracionSalida

    recibirOpcionGuardado:
        mGets guardadoPartida

    cmp byte[guardadoPartida+1], 0
    jne guardadoInvalido

    cmp byte[guardadoPartida], 's'
    je guardarPartida

    cmp byte[guardadoPartida], 'n'
    je removerArchivo

    guardadoInvalido:
        mPuts msgOpcionInvalida
        jmp recibirOpcionGuardado

    removerArchivo:
        mCommand cmdLimpiarPantalla

        cmp byte[yaHabiaGuardado], 's' ; Si ya había guardado la partida, la borramos
        jne mostrarEstadisticas
        
        mCommand cmdBorrarArchivoPartida
        mov byte[yaHabiaGuardado], 'n' ; Para la próxima vez que se quiera salir, no se borra nada
        jmp mostrarEstadisticas

guardarPartida:
    mov byte[yaHabiaGuardado], 's'
    mOpenFile nombreArchivo, modoEscritura
    call agregarDatosPartida
    mCloseFile idArchGuardado

    mPuts msgPartidaGuardada
    ret    

agregarDatosPartida:
    mWriteLine tableroEnJuego, 116, 1

    mWriteLine yaHabiaGuardado, 1, 1 ; Guardamos si ya había guardado la partida

    mWriteLine turnoDe, 1, 1 ; Guardamos el turno actual

    mWriteLine movimientosOfic1, 8, 1
    mWriteLine movimientosOfic2, 8, 1

    mWriteLine movOfic1Adelante, 8, 1
    mWriteLine movOfic1Derecha, 8, 1
    mWriteLine movOfic1Izquierda, 8, 1
    mWriteLine movOfic1Atras, 8, 1
    mWriteLine movOfic1Diagonal, 8, 1
    mWriteLine movOfic1DiagArribaDer, 8, 1
    mWriteLine movOfic1DiagArribaIzq, 8, 1
    mWriteLine movOfic1DiagAbajoDer, 8, 1
    mWriteLine movOfic1DiagAbajoIzq, 8, 1

    mWriteLine movOfic2Adelante, 8, 1
    mWriteLine movOfic2Derecha, 8, 1
    mWriteLine movOfic2Izquierda, 8, 1
    mWriteLine movOfic2Atras, 8, 1
    mWriteLine movOfic2Diagonal, 8, 1
    mWriteLine movOfic2DiagArribaDer, 8, 1
    mWriteLine movOfic2DiagArribaIzq, 8, 1
    mWriteLine movOfic2DiagAbajoDer, 8, 1
    mWriteLine movOfic2DiagAbajoIzq, 8, 1

    mWriteLine cantSoldCapturados, 8, 1
    mWriteLine cantOficInvalidados, 8, 1

    mWriteLine casillaOfic1, 8, 1
    mWriteLine casillaOfic1+8, 8, 1

    mWriteLine casillaOfic2, 8, 1
    mWriteLine casillaOfic2+8, 8, 1

    mWriteLine cantCapturasOfic1, 8, 1
    mWriteLine cantCapturasOfic2, 8, 1

    ret

; --------------------------------------------------------------------------------------------
; RUTINA PARA OBTENER LOS DATOS DE UNA PARTIDA GUARDADA
; --------------------------------------------------------------------------------------------

abrirPartidaGuardada:
    ; Recreamos el tablero guardado
    mReadLine tableroEnJuego, 116, 1

    mReadLine yaHabiaGuardado, 1, 1
    mReadLine turnoDe, 1, 1

    mReadLine movimientosOfic1, 8, 1
    mReadLine movimientosOfic2, 8, 1

    mReadLine movOfic1Adelante, 8, 1
    mReadLine movOfic1Derecha, 8, 1
    mReadLine movOfic1Izquierda, 8, 1
    mReadLine movOfic1Atras, 8, 1
    mReadLine movOfic1Diagonal, 8, 1
    mReadLine movOfic1DiagArribaDer, 8, 1
    mReadLine movOfic1DiagArribaIzq, 8, 1
    mReadLine movOfic1DiagAbajoDer, 8, 1
    mReadLine movOfic1DiagAbajoIzq, 8, 1

    mReadLine movOfic2Adelante, 8, 1
    mReadLine movOfic2Derecha, 8, 1
    mReadLine movOfic2Izquierda, 8, 1
    mReadLine movOfic2Atras, 8, 1
    mReadLine movOfic2Diagonal, 8, 1
    mReadLine movOfic2DiagArribaDer, 8, 1
    mReadLine movOfic2DiagArribaIzq, 8, 1
    mReadLine movOfic2DiagAbajoDer, 8, 1
    mReadLine movOfic2DiagAbajoIzq, 8, 1

    mReadLine cantSoldCapturados, 8, 1
    mReadLine cantOficInvalidados, 8, 1

    mReadLine casillaOfic1, 8, 1
    mReadLine casillaOfic1+8, 8, 1

    mReadLine casillaOfic2, 8, 1
    mReadLine casillaOfic2+8, 8, 1

    mReadLine cantCapturasOfic1, 8, 1
    mReadLine cantCapturasOfic2, 8, 1

    ret

; --------------------------------------------------------------------------------------------
; FIN DE LAS SUBRUTINAS
; --------------------------------------------------------------------------------------------