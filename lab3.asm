; R0 File Pointer ARRAY
; R1 MASK
; R2 Length of array
; R3 FILE ITEM
; R5 FILE ITEM
; R4 inner loop index
; R6

.ORIG x3000

LD R0, ARRAY; LOAD x4000 to R0
LD R1, MASK; LOAD MASK(xFFF0) to R1
AND R2, R2, #0 ; LENGTH OF ARRAY
AND R4, R4, #0 ; 

FINDLEN LDR R3, R0, #0
AND R3, R3, R1
BRZ FOUNDLEN
ADD R0, R0, #1
ADD R2, R2, #1
BRnzp FINDLEN

FOUNDLEN ADD R2, R2, #0
BRz ENDLOOP


SORT LD R0, ARRAY 
ADD R2, R2, #-1
BRNZ ENDLOOP
ADD R4, R2, #0

INNERLOOP
LDR R3, R0, #0 ; (i)th item
AND R3, R3, R1 ; mask out
LDR R5, R0, #1 ; (i+1)th item
AND R5, R5, R1 ; mask out
NOT R5, R5
ADD R5, R5, #1 ; negate (i+1)th item
ADD R6, R3, R5 ; R6 = (i)th - (i+1)th item
BRnz NOSWAP
LDR R3, R0, #0 ; Retrive original item value before swap
LDR R5, R0, #1
STR R3, R0, #1 ; Swap
STR R5, R0, #0

NOSWAP ADD R0, R0, #1
ADD R4, R4, #-1 ; decrement inner loop counter
BRP INNERLOOP
BRNZP SORT

ENDLOOP HALT

ARRAY .FILL x4000
MASK .FILL xFFF0

.END