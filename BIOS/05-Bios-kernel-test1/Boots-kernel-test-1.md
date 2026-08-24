# Boots – kernel test 1

## Compilation

```bash
nasm -f elf32 boot.asm -o boot.o
nasm -f elf32 entry.asm -o entry.o
nasm -f elf32 ascii.asm -o ascii.o
gcc -m32 -ffreestanding -fno-pie -c kernel_main.c -o kernel.o
ld -m elf_i386 -T linker.ld -o disk.bin ascii.o boot.o entry.o kernel.o
od -A d -t x1 -j 508 -N 4 disk.bin
qemu-system-x86_64 -hda disk.bin
```
![kernel1](images/kernel1.png)

![kernel2](images/kernel2.png)


## Boot.asm

```asm
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
CODE_SEG equ GDT_code - GDT_start ; initialisation des constantes code seg
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
```

## Entry.asm

```asm
;entry.asm

section .text
bits 32
global _start
extern kernel_main

DATA_SEG equ 0x10

_start:
mov ax, DATA_SEG
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax
mov esp, kernel_stack_top
call kernel_main
cli

.hang:
hlt
jmp .hang

section .bss
align 4
kernel_stack_bottom: equ $
resb 16384
kernel_stack_top :
```

## Kernel_main.c

```c
//petit kernel en C

void kernel_main (void) {

//volatile tells the compiler not to optimize anything that has to do with the volatile variable.
//source : https://stackoverflow.com/questions/246127/why-is-volatile-needed-in-c
//le short contient 2 octets donc il aurait fallu trouver une autre manière de rmleplir le tableau. On va
//donc prendre le char qui fait un seul octets

volatile char * vga = (volatile char *) 0XB8000;
const char couleur = 0x2F;
const char * msg = "Howdy du nouveau nouveau monde !!!!";
//int msgTaille = strlen(msg) - 1;

int i = 0;
int j = 0;

//on rentre dnas la boucle pour afficher le message

while(msg[i] != 0){

vga[j] = msg[i];
vga[j+1] = couleur;
i++;
j = j + 2;

}

//on fait une boucle à l'infini pour éviter que le noyau ne s'arrete.

while (1) {

//rien ici

}
}
```

## Linker.ld

```ld
ENTRY(boot)
OUTPUT_FORMAT("binary")
SECTIONS {

    . = 0x7c00;

    .boot :
    {
        *(.boot)
        . = 510;
        SHORT(0xaa55)
    }

    . = 0x7E00;

    .text :
    {
        *(.text)
    }

    .rodata :
    {
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(.bss)
    }
}
```

## Avec le background en couleur

![kernel2](images/kernel3.png)
