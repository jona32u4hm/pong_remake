SECTION "Memory Routines", ROM0


; memLoad: "copies" memory from Source to Destiny
;   hl: Source.
;   de: Destiny.
;   bc: number of bytes.
memLoad::
	inc	b
	inc	c
	jr	.skip
.loop	ld	a,[hl+]
	ld	[de],a
	inc	de
.skip	dec	c
	jr	nz,.loop
	dec	b
	jr	nz,.loop
	ret
	
; mapLoad: "copies" a map from Source to Destiny.
; ONLY USED WHEN SCREEN IS OFF
;   hl: Source.
;   de: Destiny.
;Map dimension:
;   b: number of tiles x (start 0).
;	c: number of tiles y (start 0).
mapLoad::
	.y
	push bc;save b value ( will be used in .x loop)
	.x
		; load tile number
		ld      a,[hl+]
		ld	[de],a
		inc de


		;check if we're done on x dimension loop
		ld a, b
		dec b
		dec a
		jr nz, .x

	pop bc;get b value back

	;move de pointer to next line
	ld a, e
	and a, %11100000 ;get the last line start address, which
					 ;    was an even number in the higher nibble
	add $20
	ld e,a
	ld a, d
	inc a
	sbc 1
	ld d, a



	;check if we're done on y dimension
	ld a, c
	dec c
	dec a
	jr nz, .y
ret