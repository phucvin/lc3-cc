.ORIG x3000
LD R5, BOTTOM_OF_STACK
LD R6, BOTTOM_OF_STACK
JSR main
HALT
BOTTOM_OF_STACK .FILL xF000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void main()
main
PUSH R7
PUSH R5
.COPY R5, R6
ADD R6, R6, #-5
; end of prologue
.ZERO R0
ADD R0, R0, #1
STR R0, R5, #-1
.ZERO R0
ADD R0, R0, #2
STR R0, R5, #-2
.ZERO R0
ADD R0, R0, #3
STR R0, R5, #-3
.ZERO R0
ADD R0, R0, #4
STR R0, R5, #-4
.ZERO R0
ADD R0, R0, #5
STR R0, R5, #-5
LDR R0, R5, #-1 ; load a
LDR R1, R5, #-2 ; load b
ADD R0, R0, R1
LDR R1, R5, #-3 ; load c
ADD R0, R0, R1
LDR R1, R5, #-4 ; load d
ADD R0, R0, R1
LDR R1, R5, #-5 ; load e
ADD R0, R0, R1
STR R0, R5, #2
BR main_ret
; epilogue
main_ret
ADD R6, R6, #5
POP R5
POP R7
RET
.END
