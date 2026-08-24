section .boot
bits 16
global boot
boot:

;ce programme fait office de pont entre le bootloader et le kernel 


	mov [disk], dl ; on récupère le numéro du disk pour le secteur 2

	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, 0x7C00
	jmp init_noyau
	
init_noyau:

	mov ah, 0x2
	mov al, 20
	mov ch, 0
	mov dh, 0
	mov cl, 2
	mov dl, [disk]
	mov bx, 0x7E00
	int 0x13

;configurer le background et la couleur 
SETBACKGROUND:
	mov ah, 0x06  ; https://www.ctyme.com/intr/rb-0096.htm
	xor al, al ; on efface la fenetre
	xor cx, cx ;ligne et colonne sur le coté droit de la fentre on met a 0
	mov dx, 0x184f ; définit le coin bas-droit de la zone à effacer à la ligne 0x18 (24) et colonne 0x4f (79)
	mov bh, 0x04 ; backround et la couleur du texte (https://en.wikipedia.org/wiki/BIOS_color_attributes) ici on veut que le background soit de couleur verte et que le texte soit en blanc
	int 0x10

;------------affichage du premier secteur-------------------
sector1:

	mov si, hello1
	mov ah, 0x0e
	jmp affichage1
	
affichage1:

	lodsb
	cmp al, 0
	je init_mode_protege
	int 0x10
	jmp affichage1
	
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

init_mode_protege:

	cli
	lgdt [GDT_descriptor]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp CODE_SEG:0x7E00 ; long jmp vers le nouveau secteur

hello1: db "Bonjour de l'ancien temps ! ", 0
;init du disk
disk : db 0
