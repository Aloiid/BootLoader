ENTRY(boot)
OUTPUT_FORMAT("binary")
SECTIONS {
    . = 0x7c00;
    .boot :
    {
    	*(.boot)
    }
    . = 0x7E00;          /* ← force explicitement stage2 à 0x7E00 */
    .text :
    {        
        ascii.o(.text)      /* l'ASCII art en premier (à 0x7E00) */
        entry.o(.text)      /* puis on jmp vers le pont */
        *(.text)            /* et enfin le kernel s'exécute*/
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
