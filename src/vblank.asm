SECTION "VBlank Routine", ROM0

DMACode::
    LOAD "DMA routine", HRAM[$FF80]
VBlankISR::
    push af
    ld a, HIGH(OAM_Source)
    ldh [$FF46], a  ; start DMA transfer (starts right after instruction)
    ld a, 40        ; delay for a total of 4×40 = 160 M-cycles
.wait
    dec a           ; 1 M-cycle
    jr nz, .wait    ; 3 M-cycles
    pop af
    reti
    ENDL
DMACodeEnd::

