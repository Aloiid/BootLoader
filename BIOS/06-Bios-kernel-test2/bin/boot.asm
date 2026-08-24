;boot.asm 
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

;------------affichage du premier secteur-------------------
sector1:

	mov si, hello1
	mov ah, 0x0e

	
affichage1:

	lodsb
	cmp al, 0
	je 0x7E00
	int 0x10
	jmp affichage1

hello1: db "Bonjour de l'ancien temps ! ", 0

;init du disk
disk : db 0

times 510 - ($-$$) db 0
dw 0xaa55
