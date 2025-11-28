INCLUDE "include/hardware.inc"

SECTION "Main", ROM0

Setup::
	di	; disable interrupts
	ld	SP, $FFFF
	
	;-------- DMA Setup --------
	ld	de, VBlankISR
	ld	hl, DMACode
	ld	bc, DMACodeEnd - DMACode
	call	memLoad

	;set interrupt flags:
	ld a, IF_VBLANK
	ld [rIE], a
	ei
	;-------- Configure LCD --------
	ld	a, [rLCDC]	
	or	LCDC_OBJ_ON	
	or	LCDC_OBJ_8	
	ld	[rLCDC], a	
	;configure palettes
    ld a, %11100100
	ld [rBGP], a
	ld a, %11100100
	ld [rOBP0], a
	ld a, %00011011
	ld [rOBP1], a
	nop
	halt
	nop
	;------- LOAD TILES --------
	;stop lcd
.waitVBlank
	nop
    ldh a, [rSTAT]
	and %11
	cp %01
    jr nz, .waitVBlank 
	ld	a, [rLCDC]
	and LCDC_OFF	; turn off lcd by toggling 
	ld	[rLCDC], a	
	;load tiles
	ld	hl, Tiles	
	ld	de, $8000 ;vram tile mem
	ld	bc, TilesEnd - Tiles
	call	memLoad
	;turn LCD ON again
	ld	a, [rLCDC]
	or	LCDC_ON
	ld	[rLCDC], a	


	
	jr @
