;bootloader simple 3 avec ascii et on change le fond avec les interrupteurs bios 

bits 16
[org 0x7C00]


;configurer le background et la couleur 
SETBACKGROUND:
mov ah, 0x06  ; https://www.ctyme.com/intr/rb-0096.htm
xor al, al ; on efface la fenetre
xor cx, cx ;ligne et colonne sur le coté droit de la fentre on met a 0
mov dx, 0x184f ; définit le coin bas-droit de la zone à effacer à la ligne 0x18 (24) et colonne 0x4f (79)
mov bh, 0x2F ; backround et la couleur du texte (https://en.wikipedia.org/wiki/BIOS_color_attributes) ici on veut que le background soit de couleur verte et que le texte soit en blanc
int 0x10

start:

mov si, ASCII ; on met l'adresse de l'ascii dans si
mov ah, 0x0e

BOUCLE:
lodsb
cmp al, 0
je end
int 0x10
jmp BOUCLE

end:
jmp end

call SETBACKGROUND ; on appelle la routine juste après avoir initialisé le texte

ASCII: 
	db "          uuUUUUUUUUuu",13,10,"     uuUUUUUUUUUUUUUUUUUuu",13,10,"    uUUUUUUUUUUUUUUUUUUUUUu",13,10,"  uUUUUUUUUUUUUUUUUUUUUUUUUUu",13,10,"  uUUUUUUUUUUUUUUUUUUUUUUUUUu",13,10,"  uUUUU       UUU       UUUUu",13,10, "   UUU        uUu        UUU",13,10,"   UUUu      uUUUu     uUUU",13,10,"    UUUUuuUUU     UUUuuUUUU",13,10, "     UUUUUUU       UUUUUUU",13,10, "       uUUUUUUUuUUUUUUUu",13,10,"           uUUUUUUUu",13,10,"         UUUUUuUuUuUUU",13,10,"           UUUUUUUUU",13,10,13,10,"  Hello from Aloiid YOLO", 0

; routine de fin 

times 510 - ($-$$) db 0
dw 0xaa55

