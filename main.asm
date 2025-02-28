; main.asm
.inesprg 1   ; 1x 16KB PRG code
.ineschr 1   ; 1x 8KB CHR data
.inesmap 0   ; NES Mapper 0
.inesmir 1   ; Vertical mirroring

.org $C000

RESET:
    SEI             ; Disable interrupts
    CLD             ; Disable decimal mode
    LDX #$40
    STX $4017       ; Disable APU frame IRQ
    LDX #$FF
    TXS             ; Set up stack

    INX
    STX $2000       ; Disable NMI
    STX $2001       ; Disable rendering
    STX $4010       ; Disable DMC IRQs

    LDX #$00        ; Clear memory
ClearMem:
    STA $0000, x
    STA $0100, x
    STA $0200, x
    STA $0300, x
    INX
    BNE ClearMem

    JMP Start

NMI:
    RTI

Start:
    ; Load palette
    LDA #$3F
    STA $2006
    LDA #$00
    STA $2006

    LDX #$00
LoadPalette:
    LDA palette, x
    STA $2007
    INX
    CPX #32
    BNE LoadPalette

    ; Load background
    LDA #$21
    STA $2006
    LDA #$00
    STA $2006

    LDX #$00
LoadBackground:
    LDA background, x
    STA $2007
    INX
    CPX #192
    BNE LoadBackground

    ; Enable NMI and rendering
    LDA #%10010000
    STA $2000
    LDA #%00011110
    STA $2001

Forever:
    JMP Forever

    .org $FFFA
    .dw NMI
    .dw RESET
    .dw 0