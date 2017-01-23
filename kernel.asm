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
    MOV DX,offset campana
    MOV SI, 0800h
    ADD SI, DX
    CALL escribe_texto



; Sección de lectura de teclas.
    MOV DH,00h
    MOV DL,04h

    XOR BX, BX
Teclazo:  MOV AH,0000h
    INT 16h
    CMP AL,08h
        JE Retroceso
    MOV cadena[BX], AL
    CMP AL,0Dh
    JE  compara
    MOV AH,0Ah
    MOV BH,00h
    MOV CX,01h
    INT 10h
    MOV AH,03h
    INT 10h     
    inc DL   
    MOV AH,02h
    MOV BH,00h
    INT 10h
    inc BX
    jmp Teclazo
    Retroceso:
    MOV AH,03h
    INT 10h
    CMP DL,06h
    ja RetrocesoMen 
    jnz Teclazo 
    RetrocesoMen:
    sub DL,1
    MOV AH,02h
    MOV BH,00h
    INT 10h 
    MOV AL,20h  
    MOV AH,0Ah
    MOV BH,00h
    MOV CX,01h
    INT 10h
    DEC BX
    jmp Teclazo

compara:

xor bx, bx
cmp cadena[bx], "?"
je ayuda
cmp cadena[bx], "v"
je version
cmp cadena[bx], "c"
je borrador
cmp cadena[bx], "r"
je reinicio
cmp cadena[bx], "b"
je carga
cmp cadena[bx], "h"
je apaga
cmp cadena[bx], "i"
je informa

jne error
