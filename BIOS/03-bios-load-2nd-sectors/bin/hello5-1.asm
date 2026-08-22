; load more disk avec le mode protégé (a refaire)

bits 16

[org 0x7C00]

start: 

	mov [disk], dl ;numéro du disque dans dl 
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

init_sector:

	mov ah, 0x2 ; fonction pour lire les secteurs
	mov al, 1 ;le secteur qu'on souhaite lire
	mov ch, 0 ; cylinder idx ??
	mov dh, 0; tete d'idx
	mov cl, 2 ; sector idx 
	mov dl, [disk] ; disk idx, ici le numero du disque est automatiquement mis dans dl 
	mov bx, HELLO_NEXT_SECTOR; target pointeur
	int 0x13 ;on call l'interruption BIOS


jmp mode_protege

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


;mode protégé

init_mode_protege:

cli
lgdt [GDT_descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:mode_protege

mode_protege:

mov esi, HELLO_FIRST_SECTOR
mov edi, 0xB8000
mov ah, 0x4e

HELLO_FIRST_SECTOR:
db "Bonjour moi être premier secteur, moi faire partir du mode protégé", 0

DISPLAY_STRING:
lodsb
cmp al, 0
je END
mov [edi+1], ah
add edi, 2
jmp DISPLAY_STRING



END: 
jmp $

times 510 - ($-$$) db 0
dw 0xaa55


;--------------------deuxieme secteurs-------------------

bits 32


HELLO_NEXT_SECTOR:
db "Bonjour je viens de l'autre secteur !" , 0

sector2:

mov esi, HELLO_NEXT_SECTOR
mov edi, 0xB8000
mov eax, 0x4e


INIT_DISPLAY:
lodsb
or al, 1
je END2
mov [edi+1], eax 
add edi, 2
jmp INIT_DISPLAY

END2:
jmp $


times 1020 - ($-$$) db 0
dw 0xaa55











