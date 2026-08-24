;ascii.asm 
section .text
bits 16
global stage2
extern _start


stage2:
	call SETBACKGROUND
	mov si, hello1
	mov ah, 0x0e
	call affichage_ascii
	mov si, ASCII
	mov ah, 0x0e
	call affichage_ascii
	jmp init_mode_protege

affichage_ascii:
	
	lodsb
	cmp al, 0
	je fin_affichage
	int 0x10
	jmp affichage_ascii

fin_affichage: 
	ret
	
	;configurer le background et la couleur 
SETBACKGROUND:
	mov ah, 0x06  ; https://www.ctyme.com/intr/rb-0096.htm
	xor al, al ; on efface la fenetre
	xor cx, cx ;ligne et colonne sur le coté droit de la fentre on met a 0
	mov dx, 0x184f ; définit le coin bas-droit de la zone à effacer à la ligne 0x18 (24) et colonne 0x4f (79)
	mov bh, 0x1E ; backround et la couleur du texte
	int 0x10
	ret

init_mode_protege:

	cli
	lgdt [GDT_descriptor]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp CODE_SEG:jmp_protected_mode ; long jmp vers le protected mode
	
	
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



bits 32

jmp_protected_mode:
	jmp _start

hello1: db "Bonjour de l'ancien temps (#bits16) ! ", 0

ASCII:
	db '       _==/          i     i          \==_', 13,10
	db '     /XX/            |\___/|            \XX\', 13,10
	db '   /XXXX\            |XXXXX|            /XXXX\', 13,10
	db '  |XXXXXX\_         _XXXXXXX_         _/XXXXXX|', 13,10
	db ' XXXXXXXXXXXxxxxxxxXXXXXXXXXXXxxxxxxxXXXXXXXXXXX', 13,10
	db '|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|', 13,10
	db 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 13,10
	db '|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|', 13,10
	db ' XXXXXX/^^^^', 34, '\XXXXXXXXXXXXXXXXXXXXX/^^^^^\XXXXXX', 13,10
	db '  |XXX|       \XXX/^^\XXXXX/^^\XXX/       |XXX|', 13,10
	db '    \XX\       \X/    \XXX/    \X/       /XX/', 13,10
	db '       ', 34, '\       ', 34, '      \X/      ', 34, '      /', 34, 13,10 
	db "             hello Friend, this is BATGRIL AKA ORACLE NOW!", 0
	db 0


