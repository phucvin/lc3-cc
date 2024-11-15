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
; end of prologue
LEA R0, str_hellon
PUTS
NEWLN
OUT
; epilogue
main_ret
POP R5
POP R7
RET
str_hellon .STRINGZ "hello\n"
.END
