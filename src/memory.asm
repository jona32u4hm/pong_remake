SECTION "Memory Routines", ROM0


; memLoad: "copies" memory from Source to Destiny
;   hl: Source
;   de: Destiny
;   bc: number of bytes
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

