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
