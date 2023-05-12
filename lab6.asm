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
BRz NOMATCH ; not found in reserved room list

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

CANTFIND ; not found in available room list
LEA R0, NOTEXIST
TRAP x22
BR END

FOUND ; found in reserved room list
LEA R1, INPUTSTRING
PRINT2
LDR R0, R1, #0
BRz PRINT2END
TRAP x21
ADD R1, R1, #1
BR PRINT2

PRINT2END 
LEA R0, NOTAVAILABLE ; room is already reserved
TRAP x22
BR END





NOMATCH

LD R0, PTR
ADD R0, R0, #1 ; R0 = x4001

LOOP2
LEA R3, INPUTSTRING ; input string starting address
LDR R0, R0, #0 ; R0 = x5000
BRz CANTFIND ; not found in available room list

ADD R1, R0, #1 ; R1 = x5001
LDR R1, R1, #0 ; R1 = x5002 (value of first node - starting address)

CHECK
LDR R2, R1, #0
BRz FINALCHECK2 ; reached the end of room number
NOT R2, R2
ADD R2, R2, #1 ; negate room number

LDR R4, R3, #0
BRz LOOP2       ; reached the end of input string
ADD R4, R2, R4 ; compare room number and input string
BRnp LOOP2

ADD R1, R1, #1 ; next letter in room number
ADD R3, R3, #1 ; next letter in input char
BR CHECK

FINALCHECK2
LDR R4, R3, #0 
BRz RESERVE ; if input string has reached the end as well
BRnp LOOP2



RESERVE ; found in the available room list
        ; R0 = address of found node

LD R1, PTR ; R1 = head pointer to reserved room list
LDR R2, R1, #0 ; R2 = (previous) head node

STR R0, R1, #0 ; now head ptr points to inserted node

LDR R3, R0, #0 ; R3 = what inserted node previously pointed
STR R2, R0, #0 ; now inserted node points to prev head node

ADD R1, R1, #1 ; head pointer to available room list


FINDPREVNODE
LDR R2, R1, #0
NOT R4, R2
ADD R4, R4, #1
ADD R5, R4, R0
BRz DELNODE
AND R1, R1, #0
ADD R1, R1, R2
BR FINDPREVNODE

DELNODE
STR R3, R1, #0

LEA R0, SUCCESS
TRAP x22
LEA R1, INPUTSTRING
PRINT
LDR R0, R1, #0
BRz PRINTEND
TRAP x21
ADD R1, R1, #1
BR PRINT

PRINTEND
LEA R0, RESERVED
TRAP x22

END
HALT

PTR .FILL x4000 ; x4000 - reserved rooms
                ; x4001 - available rooms
PROMPT .STRINGZ "Type the room to be reserved and press Enter: " ; 
NOTEXIST .STRINGZ "ERROR: The requested room does not exist in the database."
NOTAVAILABLE .STRINGZ " is currently NOT available."
SUCCESS .STRINGZ "Success! "
RESERVED .STRINGZ " has been reserved!"
INPUTSTRING .BLKW #100

.END