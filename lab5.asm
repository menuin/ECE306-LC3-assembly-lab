.ORIG x3000

LEA R0, PROMPT
TRAP x22

LEA R1, INPUTSTRING
AND R2, R2, #0
ADD R2, R2, #10 ; ascii code for ENTER
NOT R2, R2
ADD R2, R2, #1 ; negate

GETSTRING
TRAP x20 ; read char into R0
TRAP x21

ADD R3, R0, R2 ; compare input char and ENTER
BRz ENTER ; ENTER detected

STR R0, R1, #0 ; increase inputstring pointer
ADD R1, R1, #1
BR GETSTRING
ENTER 




LD R0, PTR  ; R0 = X4000
LOOP
LEA R3, INPUTSTRING ; input string starting address
LDR R0, R0, #0 ; R0 = X4002
BRz CANTFIND ; if there is no node left

ADD R1, R0, #1 ; R1 = X4003
LDR R1, R1, #0 ; R1 = X4800 (value of first node - starting address)

CHECKROOM
LDR R2, R1, #0
BRz FINALCHECK ; reached the end of room number
NOT R2, R2
ADD R2, R2, #1 ; negate room number

LDR R4, R3, #0
BRz LOOP       ; reached the end of input string
ADD R4, R2, R4 ; compare room number and input string
BRnp LOOP

ADD R1, R1, #1 ; next letter in room number
ADD R3, R3, #1 ; next letter in input char
BR CHECKROOM

FINALCHECK
LDR R4, R3, #0 
BRz FOUND ; if input string has reached the end as well
BRnp LOOP

CANTFIND
LEA R1, INPUTSTRING
PRINT
LDR R0, R1, #0
BRz PRINTEND
TRAP x21
ADD R1, R1, #1
BR PRINT

PRINTEND
LEA R0, NOTAVAILABLE
TRAP x22
BR END

FOUND
LEA R1, INPUTSTRING
PRINT2
LDR R0, R1, #0
BRz PRINT2END
TRAP x21
ADD R1, R1, #1
BR PRINT2

PRINT2END
LEA R0, AVAILABLE
TRAP x22

END
HALT

PTR .FILL x4000
PROMPT .STRINGZ "Type the room to be reserved and press Enter: " ; 
AVAILABLE .STRINGZ " is currently available!"
NOTAVAILABLE .STRINGZ " is NOT currently available."
INPUTSTRING .BLKW #100

.END