.MODEL tiny
.STACK
    org 00h
.CODE
DATA:
    JMP INICIO



display         db 0Dh, 0Ah, 0Dh, 0Ah
db "       _  ___ _        _  ___      ", 0Dh, 0Ah
db "      | |/ (_) |_ __ _( )/ _ \ ___ ", 0Dh, 0Ah
db "      | ' /| | __/ _` |/| | | / __|", 0Dh, 0Ah
db "      | . \| | || (_| | | |_| \__ \", 0Dh, 0Ah
db "      |_|\_\_|\__\__,_|  \___/|___/", 0Dh, 0Ah
        db 0Ah, 0Ah, 0Ah, 0Ah,"   Cargando...",0Ah,0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Dh
        db "   Kita'OS ver. 1.0.0                                                       ", 00h

versionmsj        db 0Dh,0Ah,"   Kita'OS ver. 1.0.0                                                       ", 0Dh,0Ah,0Dh,0Ah,00h

infomsj     db " S.O. por Batuto", 0Dh, 0Ah, "Algún lugar del Internet",0Dh,0Ah,
                db "Algún rincón de la galaxia",0Dh,0Ah,0Ah
        db "22/JAN/2017",0Dh,0Ah,"",0Ah,0Dh,00h
ayudamsj          db 0Dh,0Ah,"Ayuda:",0Dh,0Ah,
        db         "? > Despliega este mensaje de ayuda."
        db 0Dh,0Ah,"cls > Limpia la pantalla del terminal."
        db 0Dh,0Ah,"col > Cambia los colores del terminal. (Se restablecen al borrar la pantalla)"
        db 0Dh,0Ah,"ver > Despliega la version del sistema."
        db 0Dh,0Ah,"vid > Cambia video a modo grafico."
        db 0Dh,0Ah,"info > Despliega la informacion del sistema."
        db 0Dh,0Ah,"reboot > Reinicia el equipo."
        db 0Dh,0Ah,"boot > Carga el sistema operativo del disco principal."
        db 0Dh,0Ah,"halt > Apaga el equipo."
        db 0Dh,0Ah,0Ah,00h
campana         db 07h, 00h
prompt  db "A:/> ",00h
cadena  db 20 DUP (00h)
errormsj  db 0Dh,0Ah," No se encontro la orden"
saltoeco db 0Dh, 0Ah, 00h

;><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
INICIO:
;><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
    MOV DX, OFFSET campana
    MOV SI, 0800h
    ADD SI, DX
    CALL escribe_texto
    ; ------------------
    CALL borra_pantalla
    MOV DX, OFFSET display
    MOV SI, 0800h
    ADD SI, DX
    CALL escribe_texto
;><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
    MOV AH, 86H ; Función para delay con INT 15h
    MOV CX, 00BEH ; Enviamos al contador microsegundos
    MOV DX, 0000H ; Es el multiplicador
    INT 15H

;><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
    CALL borrar_pantalla
iniciosistema:              ; Entrada al promt del sistema, cursor en espera.
    MOV DX, OFFSET prompt
    MOV SI, 0800h
    ADD SI, DX
    CALL escribe_texto

;><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
; Sección de lectura de teclas.
    MOV DH, 00h
    MOV DL, 04h

    XOR BX, BX
presionatecla:  MOV AH,0000h
    INT 16h
    CMP AL, 08h
        JE retroceso
    MOV cadena[BX], AL
    CMP AL, 0Dh
    JE  compara
    MOV AH, 0Ah
    MOV BH, 00h
    MOV CX, 01h
    INT 10h
    MOV AH, 03h
    INT 10h     
    INC DL   
    MOV AH, 02h
    MOV BH, 00h
    INT 10h
    INC BX
    JMP presionatecla
    retroceso:
    MOV AH, 03h
    INT 10h
    CMP DL, 06h
    JA retrocesoborra 
    JNZ presionatecla 
    retrocesoborra:
    SUB DL, 1
    MOV AH, 02h
    MOV BH, 00h
    INT 10h 
    MOV AL, 20h  
    MOV AH, 0Ah
    MOV BH, 00h
    MOV CX, 01h
    INT 10h
    DEC BX
    JMP presionatecla


; Sección que compara la primer letra de la cadena
compara:

XOR BX, BX
CMP cadena[BX], "?"
JE ayuda
CMP cadena[BX], "v"
JE version
CMP cadena[BX], "c"
JE borrador
CMP cadena[BX], "r"
JE reinicio
CMP cadena[BX], "b"
JE bootso
CMP cadena[BX], "h"
JE apaga
CMP cadena[BX], "i"
JE informa

JNE error

;><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
; Compara a detalle

bootso: INC BX
    CMP cadena[BX], "o"
    JNE error
    INC BX
    CMP cadena[BX], "o"
    JNE error
    INC BX
    CMP cadena[BX], "t"
    JNE error
    INC BX
    CMP cadena[BX], 0Dh
    JNE error
    INT 019h
    JMP SHORT regreso

reinicio:
    INC BX
    CMP cadena[BX], "e"
    JNE error
    INC BX
    CMP cadena[BX], "b"
    JNE error
    INC BX
    CMP cadena[BX], "o"
    JNE error
    INC BX
    CMP cadena[BX], "o"
    JNE error
    INC BX
    CMP cadena[BX], "t"
    JNE error
    INC BX
    CMP cadena[BX], 0Dh
    JNE error
    MOV AX, 0040h
    MOV DS, AX
    MOV w.[0072h], 0000h       ; Cold boot.
    JMP 0FFFFh:0000h           ; Reboot!

ayuda:
    MOV DX, OFFSET ayudamsj
    MOV SI,0800h
    ADD SI,DX
    CALL escribe_texto
    JMP SHORT regreso

version: INC BX
    CMP cadena[BX], "e"
    JNE error
    INC BX
    CMP cadena[BX], "r"
    JNE error
    INC BX
    CMP cadena[BX], 0Dh
    JNE error
    MOV DX, OFFSET versionmsj
    MOV SI,0800h
    ADD SI,DX
    CALL escribe_texto
    JMP SHORT regreso

borrador: INC BX
    CMP cadena[BX], "l"
    JNE error
    INC BX
    CMP cadena[BX], "s"
    JNE error
    INC BX
    CMP cadena[BX], 0Dh
    JNE error
    CALL borra_pantalla
    JMP SHORT regreso

;><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
; Métodos 


error:
    MOV DX, OFFSET errormsj
    MOV SI, 0800h
    ADD SI, DX
    CALL escribe_texto

regreso:    JMP iniciosistema

borra_pantalla PROC NEAR
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 00h
    MOV DH, 18h
    MOV DL, 4Fh
    INT 10h
    MOV AH, 02h
    MOV BH, 00h
    MOV DX, 0000h
    INT 10h
    JMP salir
borra_pantalla ENDP

escribe_texto PROC NEAR
    LODSB           ; carga en al el caracter al que apunta si y si se incrementa
    OR AL, AL       ; pone a zf=0 si ultimo car.- 0 or 0 = 0, is there one?
    JE SHORT salir  ; sale si no (cero termina cadena)        
    MOV AH,0Eh      ; output one character to crt...
    INT 10h         ;
    JMP short escribe_texto ; regresar para mas...
 escribe_texto endp
salir:  RET


END DATA