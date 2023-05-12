; OPERATING SYSTEM CODE

.ORIG x500
        
        LD R0, VEC
        LD R1, ISR
        ; (1) Initialize interrupt vector table with the starting address of ISR.
        STR R1, R0, #0

        ; (2) Set bit 14 of KBSR. [To Enable Interrupt]
        LDI R0, KBSR
        NOT R0, R0
        LD R1, MASK       ; R1 = xBFFF
        AND R0, R0, R1
        NOT R0, R0


        ; (3) Set up system stack to enter user space. So that PC can return to the main user program at x3000.
	      ;     R6 is the Stack Pointer. Remember to Push PC and PSR in the right order. Hint: Refer State Graph
        LD R0, PSR
        LD R1, PC
        ADD R6, R6, #-1
        STR R1, R6, #0   ; push PC
        ADD R6, R6, #-1
        STR R0, R6, #0  ; push PSR
        
        
        ; (4) Enter user Program.
        RTI
        
VEC     .FILL x0180
ISR     .FILL x1700
KBSR    .FILL xFE00
MASK    .FILL xBFFF
PSR     .FILL x8002
PC      .FILL x3000

.END


; INTERRUPT SERVICE ROUTINE

.ORIG x1700
ST R0, SAVER0
ST R1, SAVER1
ST R2, SAVER2
ST R3, SAVER3
ST R7, SAVER7

; CHECK THE KIND OF CHARACTER TYPED AND PRINT THE APPROPRIATE PROMPT



    
end LD R0, SAVER0
    LD R1, SAVER1
    LD R2, SAVER2
    LD R3, SAVER3 
    LD R7, SAVER7
    RTI



MEM .FILL x4000
ASCII_NUM .FILL x-30
ASCII_LC  .FILL x-61
ASCII_UC  .FILL x-41
KBSR2 .FILL xFE00
KBDR  .FILL xFE02
DSR   .FILL xFE04
DDR   .FILL xFE06
SAVER0 .BLKW x1
SAVER1 .BLKW x1
SAVER2 .BLKW x1
SAVER3 .BLKW x1
SAVER7 .BLKW x1
STRING1 .STRINGZ "You typed a letter. I asked for a number...\n"
STRING2 .STRINGZ "Nope, try a different guess!\n"
STRING3 .STRINGZ "Yes, that's the number I was thinking of! Exiting...\n"
STRING4 .STRINGZ "I don't recognize this character, but I asked for a number...\n"
.END




; USER PROGRAM

.ORIG x3000


; MAIN USER PROGRAM
; PRINT THE MESSAGE "I'm thinking of a number between 0-9! Type your guess!" WITH A DELAY LOGIC
LEA R0, MESSAGE
TRAP x22



CNT .FILL x5000
MESSAGE .STRINGZ  "I'm thinking of a number between 0-9! Type your guess!\n"
.END