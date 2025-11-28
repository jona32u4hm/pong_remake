INCLUDE "include/hardware.inc"

SECTION "Vblank", ROM0[$0040]
    JP VBlankISR

SECTION "LCDC", ROM0[$0048]
	reti

SECTION "Timer", ROM0[$0050]
	reti

SECTION "Serial", ROM0[$0058]
	reti

SECTION "Joypad", ROM0[$0060]
	reti

SECTION "Header", ROM0[$100]
	;---------- ROM Entry Point -----------
	jp Setup

	;header space
	ds $150 - @, 0