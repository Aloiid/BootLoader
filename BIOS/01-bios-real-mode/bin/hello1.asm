;bootloader simple 1


bits 16

[org 0x7C00]

start:

mov si, HELLO ; le registre si (esi) pointe sur le début de la chaine

;boucle pour afficher toute la chaine et pas juste le premier caractère

BOUCLE:
lodsb ; registre implicite qui va récupérer la valeur dans esi la mettre dans eax et incrémenter esi donc si esi contient une chaine on va boucler sur cette chaine
cmp al, 0 ; on checke si on a atteint la fin de la chaine (\0)
je end
mov ah, 0x0e ;on affiche le texte sur l'ecran avec l'interrupteur BIOS
int 0x10
jmp BOUCLE


end:
jmp end

HELLO: 

db "HELLO this is ALIP", 0

;routine de fin




times 510 - ($-$$) db 0 ;on remplis le reste des ostets vide de 0 jusqu'a atteindre 512 octets
dw 0xaa55 ; on met la signature de fin 

