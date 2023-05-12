.ORIG x3000

LD R0, HISTPTR
LD R1, ARRPTR

; initialize histogram
LD R2, N
LD R3, E
LD R4, M
LD R5, L
LD R6, T

STR R2, R0, #0
STR R3, R0, #1
STR R4, R0, #2
STR R5, R0, #3
STR R6, R0, #4



; categorizing
LD R2, MASK
AND R7, R7, #0 ; R7 : counter

CATEGORIZE 
LDR R4, R1, #0 ; next data to categorize (unshifted)
ADD R4, R4, #0 ; end of the array
BRz ENDLOOP

AND R4, R4, R2 ; mask out data[15:4]
AND R3, R3, #0
ADD R3, R3, #12 ; count

; shift data[15:4] to data[11:0]
SHIFT
ADD R4, R4, #0
BRn SHIFT_NEG
BRzp SHIFT_POS

SHIFT_NEG
ADD R4, R4, R4
ADD R4, R4, #1
BR DECREMENT_COUNT

SHIFT_POS
ADD R4, R4, R4

DECREMENT_COUNT
ADD R3, R3, #-1
BRp SHIFT

ADD R4, R4, #0 ; check if end of the array (year = 0)
BRz ENDLOOP
ADD R7, R7, #1 ; count

; compare and categorize
AND R5, R5, #0 ; destination pointer
NOT R4, R4
ADD R4, R4, #1 ; negate year
LD R3, YEARONE
ADD R3, R4, R3 ; 1900 - year
BRzp UPDATE

ADD R5, R5, #1 ; x4501
LD R3, YEARTWO
ADD R3, R4, R3 ; 1933 - year
BRzp UPDATE

ADD R5, R5, #1 ; x4502
LD R3, YEARTHREE
ADD R3, R4, R3 ; 1967 - year
BRzp UPDATE

ADD R5, R5, #1 ; x4503
LD R3, YEARFOUR
ADD R3, R4, R3 ; 2000 - year
BRzp UPDATE 

ADD R5, R5, #1 ; 2001 and later -> x4504

UPDATE
ADD R5, R5, R0
LDR R6, R5, #0
ADD R6, R6, #1 ; add data to histogram
STR R6, R5, #0

ADD R1, R1, #1
BR CATEGORIZE

ENDLOOP




; PART 2
; R7 : length of the array
LD R1, ARRPTR

ADD R7, R7, #0 ; if there is no data
BRz NODATA

AND R0, R0, #0
ADD R0, R0, R7 ; set R0 to counter
AND R2, R2, #0 ; R2 : sum of zone numbers
AND R3, R3, #0 ; R3 : highest zone number
AND R4, R4, #0 ; R4 : lowest zone number
ADD R4, R4, #15



LOOP
LD R6, MASK_Z
LDR R5, R1, #0 ; R5 : current data 
AND R5, R5, R6 ; mask out data[3:0]
ADD R2, R2, R5 ; add zone number to sum
NOT R6, R5
ADD R6, R6, #1 ; negate current zone number -> R6

CHECK_HIGHEST
ADD R6, R3, R6 ; crnt_highest - crnt_zone#
BRzp CHECK_LOWEST
AND R3, R3, #0
ADD R3, R3, R5 ; set crnt zone # to crnt highest

CHECK_LOWEST
NOT R6, R5
ADD R6, R6, #1 ; negate current zone number
ADD R6, R4, R6 ; crnt_lowest - crnt_zone#
BRnz END_CHECK
AND R4, R4, #0
ADD R4, R4, R5 ; set crnt zone # to crnt lowest

END_CHECK

ADD R1, R1, #1
ADD R0, R0, #-1
BRp LOOP
BRnz ENDPART2



ENDPART2

; R1, R5, R6 are free
AND R1, R1, #0 ; R1 : mean (round-down)
NOT R7, R7
ADD R7, R7, #1 ; negate length (R7)

; calculate mean
MEAN 
ADD R2, R2, R7
BRn ENDMEAN
ADD R1, R1, #1
BR MEAN

ENDMEAN

; Shift mean (R1) by 8 bits
AND R5, R5, #0
ADD R5, R5, #8
SHIFTMEAN 
ADD R1, R1, #0
BRn SHIFTMEAN_NEG
BRzp SHIFTMEAN_POS

SHIFTMEAN_NEG
ADD R1, R1, R1
ADD R1, R1, #1
BR DECREMENT

SHIFTMEAN_POS
ADD R1, R1, R1
BR DECREMENT

DECREMENT
ADD R5, R5, #-1
BRp SHIFTMEAN


; Shift highest zone number (R3) by 4 bits
AND R5, R5, #0
ADD R5, R5, #4
SHIFT_H
ADD R3, R3, #0
BRn SHIFT_H_NEG
BRzp SHIFT_H_POS

SHIFT_H_NEG
ADD R3, R3, R3
ADD R3, R3, #1
BR DECREMENT_H

SHIFT_H_POS
ADD R3, R3, R3
BR DECREMENT_H

DECREMENT_H
ADD R5, R5, #-1
BRp SHIFT_H


; add mean[15:8], highest[7:4], lowest[3:0]
ADD R1, R1, R3
ADD R1, R1, R4

LD R2, HISTPTR
ADD R2, R2, #5 ; x4505

STR R1, R2, #0 ; store to mem[x4505]
BR STORED

NODATA ; store xFFFF to x4505
LD R2, F
STR R2, R1, #0

STORED
HALT

ARRPTR .FILL x4000
HISTPTR .FILL x4500

N .FILL x4E00
E .FILL x4500
M .FILL x4D00
L .FILL x4C00
T .FILL x5400
F .FILL xFFFF

YEARONE .FILL x076C
YEARTWO .FILL x078D
YEARTHREE .FILL x07AF
YEARFOUR .FILL x07D0

MASK .FILL xFFF0
MASK_Z .FILL x000F

.END