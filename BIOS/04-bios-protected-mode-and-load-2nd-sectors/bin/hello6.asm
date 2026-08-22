; load more disk in 32 bits

[org 0x7C00]
bits 16


start:

	mov [disk], dl ; on bouge le numéro du disk dans la variable disk
	
	;on met tous les segments à zéro
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	jmp init_sector2


;---------GDT INITIALISATION---------------------

GDT_start: 
	dq 0

GDT_code:
  
	dw 0xFFFF 
	dw 0x0000 ;2 octets = 16 bits 
	db 0 
	db 10011010b
	db 11001111b 
	db 0x00 

GDT_data:
	dw 0xFFFF
	dw 0
	db 0
	db 10010010b
	db 11001111b
	db 0x00

GDT_end:

GDT_descriptor: 

	dw GDT_end - GDT_start -1 ; taille limite  
	dd GDT_start ; @ du début de la structure GDT 
	CODE_SEG equ GDT_code - GDT_start ; initialisation des constantes code 	seg
	DATA_SEG equ GDT_data - GDT_start ; initialisaton de la constantes data seg
	

init_sector2:

	mov ah, 0x2
	mov al, 1
	mov ch, 0
	mov dh, 0
	mov cl, 2
	mov dl, [disk]
	mov bx, 0x7E00
	int 0x13

;on affiche le message du secteur 1 pour tester 

sector1:

	mov si, HELLO_FIRST_SECTOR

DISPLAY_STRING:
	lodsb
	cmp al, 0
	je init_mode_protege
	mov ah, 0x0e
	int 0x10
	jmp DISPLAY_STRING

;---------on passe en mode protégé-----------
init_mode_protege:

	cli
	lgdt [GDT_descriptor]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp CODE_SEG:sector2
	
;donnée du secteur 1

disk: 	db 0
HELLO_FIRST_SECTOR:
	db "Bonjour moi etre le premier secteur. ", 0

times 510-($-$$) db 0
dw 0xaa55

;------------------SECTOR2 MODE 32 BITS - 32 bits, chargé à 0x7E00--------------------

[bits 32]

sector2:

;recharger les segments de données avec DATA_SEG
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov fs, ax
	mov gs, ax

	mov esi, HELLO_NEXT_SECTOR
	mov edi, 0xB8000
	mov ah, 0x4e
	
DISPLAY_STRING2:
	lodsb
	cmp al, 0
	je END
	mov [edi], al
	mov [edi+1], ah
	add edi, 2
	jmp DISPLAY_STRING2

END:
	jmp $

HELLO_NEXT_SECTOR:
	db " Bonjour je viens du deuxieme secteurs ! " , 0

times 1024-($-$$) db 0


