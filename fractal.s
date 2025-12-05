// ARMLite Mandelbrot Zoom
        MOV     R0,#2
        STR     R0,.Resolution          // hi-res, clear pixel buffer
Main:
        LDR     R8,.PixelAreaSize       // total pixels (128*96)
        MOV     R1,#.PixelScreen        // framebuffer pointer
FrameLoop:
        LDR     R9,.InstructionCount    // time accumulator
        LSR     R0,R9,#7
        AND     R0,R0,#3
        ADD     R0,R0,#4                // shift controls zoom (4..7)
        STR     R0,ZoomShift
        MOV     R7,#0                   // pixel index
PixelLoop:
        LDR     R10,ZoomShift
        AND     R4,R7,#127              // x = n & 127
        LSR     R5,R7,#7                // y = n >> 7
        SUB     R4,R4,#64               // center around origin
        SUB     R5,R5,#48
        LSL     R4,R4,R10               // apply zoom scaling
        LSL     R5,R5,R10
        MOV     R0,#-128                // base center real (-0.5 * 256)
        ADD     R4,R4,R0
        MOV     R0,#0                   // base center imag (0)
        ADD     R5,R5,R0
        LSR     R0,R9,#5                // slow horizontal drift
        AND     R0,R0,#63
        SUB     R4,R4,R0
        LSR     R0,R9,#6                // slow vertical drift
        AND     R0,R0,#63
        SUB     R5,R5,R0
        STR     R4,TmpCR                // store c_r
        STR     R5,TmpCI                // store c_i

        MOV     R2,#0                   // z_r
        MOV     R3,#0                   // z_i
        MOV     R12,#0                  // iteration counter
IterLoop:
        // zr^2
        MOV     R4,R2
        MOV     R5,R2
        BL      MulFixed
        MOV     R10,R0
        // zi^2
        MOV     R4,R3
        MOV     R5,R3
        BL      MulFixed
        MOV     R11,R0
        ADD     R0,R10,R11
        CMP     R0,#1024                // escape radius (4.0 in Q8)
        BGT     Escaped
        // zr*zi
        MOV     R4,R2
        MOV     R5,R3
        BL      MulFixed
        LSL     R0,R0,#1                // 2*zr*zi
        LDR     R5,TmpCI
        ADD     R3,R0,R5                // new z_i
        SUB     R0,R10,R11
        LDR     R4,TmpCR
        ADD     R2,R0,R4                // new z_r
        ADD     R12,R12,#1
        CMP     R12,#32                 // max iterations
        BLT     IterLoop
        MOV     R0,#0                   // inside set -> dark
        B       Colorize
Escaped:
        MOV     R0,R12
        LSL     R0,R0,#3                // scale iterations to 0..255
Colorize:
        LSR     R4,R9,#3                // rainbow cycling
        ADD     R2,R0,R4
        AND     R2,R2,#255
        LSR     R4,R9,#5
        ADD     R3,R0,R4
        AND     R3,R3,#255
        MOV     R5,#255
        SUB     R0,R5,R0
        AND     R0,R0,#255
        MOV     R5,R2
        LSL     R5,R5,#16
        MOV     R4,R3
        LSL     R4,R4,#8
        ORR     R5,R5,R4
        ORR     R5,R5,R0
        STR     R5,[R1]

        ADD     R1,R1,#4
        ADD     R7,R7,#1
        CMP     R7,R8
        BLT     PixelLoop
        B       Main
        HALT

// Signed fixed-point multiply (Q8)
// Inputs: R4 (a), R5 (b). Output: R0 = (a*b)>>8
MulFixed:
        PUSH    {LR}
        MOV     R11,#0                 // sign flag
        CMP     R4,#0
        BLT     MulANeg
        B       MulApos
MulANeg:
        MOV     R6,#0
        SUB     R4,R6,R4
        MOV     R11,#1
MulApos:
        CMP     R5,#0
        BLT     MulBNeg
        B       MulBpos
MulBNeg:
        MOV     R6,#0
        SUB     R5,R6,R5
        EOR     R11,R11,#1
MulBpos:
        MOV     R0,#0
MulLoop:
        AND     R6,R5,#1
        CMP     R6,#0
        BEQ     SkipAdd
        ADD     R0,R0,R4
SkipAdd:
        LSL     R4,R4,#1
        LSR     R5,R5,#1
        CMP     R5,#0
        BNE     MulLoop
        CMP     R11,#0
        BEQ     MulShift
        MOV     R6,#0
        SUB     R0,R6,R0
MulShift:
        LSR     R0,R0,#8
        POP     {LR}
        RET

        .DATA
ZoomShift:  .WORD   0
TmpCR:      .WORD   0
TmpCI:      .WORD   0
