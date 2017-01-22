.MODEL tiny
.STACK
org 00h
.CODE
inicio:
; Rutina que carga en memoria el kernel y le cede el control.
    XOR  AX,AX      ; Se pone AX en 0
    MOV  ES,AX      ; ES=0000, segmento de carga 0
    MOV  AH,02h     ; Función de lectura de sectores
    MOV  AL,01h     ; Número de sectores a leer, 1 sector a leer
    MOV  CH,00h     ; Pista 0
    MOV  CL,02h     ; Número de sector a cargar
    MOV  DX,80h     ; Código de disco 0,1 a,b 80H,81H- c,d...
    MOV  BX,0800h   ; ES:BX 0000:0800 dirección donde se carga el sector leído
    INT  13h
    JMP  BX         ; saltamos a ES:BX - 0000:0800, pasa el control al Módulo de Carga BootCLS.bin

END inicio