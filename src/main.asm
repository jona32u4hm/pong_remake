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
	and ~LCDC_ON 
	ld	[rLCDC], a	
	;load tiles
	ld	hl, Tiles	
	ld	de, $8000 ;vram tile mem
	ld	bc, TilesEnd - Tiles
	call	memLoad
	;load vram map for tenniscourt
	ld	hl, Tennis
	ld	de, $9800
	ld	bc, $1412 ;20 x 18 ($15 -1 x $13 -1)
	call mapLoad

	;turn LCD ON again
	ld	a, [rLCDC]
	or	LCDC_ON
	ld	[rLCDC], a	

	;set OAM shadow RAM to 0 (hides all objects)
	ld a, 0 
	ld de, OAM_Other
	ld bc, setUp2Here - OAM_Other
	call memSet
	;intialize paddle and ball objects
	ld	hl, PaddleObj	
	ld	de, OAM_Source ;vram tile mem
	ld	bc, PaddleObjEND - PaddleObj
	call	memLoad
	;setup paddle velocity to offsetted zero used for negative numbers
	ld a, PADDLE_ZERO_OFFSET
	ld [velocityP1], a
	ld [velocityP2], a



Main::
	halt 
	nop 

	call readJoyPad
	call updatePaddles

	jr Main
