; Program Name:           Lab14.1.asm

; Program Description:	Implement the following C++ code in assembly language. Substitute calls
;						to WriteString for the printf() function calls:
;								double X;
;								double Y;
;								if( X < Y )
;								    printf("X is lower\n");
;								else
;								    printf("X is not lower\n");
; Date: 11/19/2015


INCLUDE Irvine32.inc

.data
valX REAL8 7.5 
valY REAL8 2.5

msg_xLy BYTE "X is lower",0
msg_yLx BYTE "X is not lower",0

.code
main PROC 

	fld valX						; move valX into stack

	FCOMP valY						; compare to valY
	fnstsw ax						; move status word into ax
    sahf							; copy AH into eflags
	jnb y_below_x					; is x<y?

X_BELOW_Y:
	mov edx, OFFSET msg_xLy
	jmp WRITE_OUT

Y_BELOW_X:
	mov edx, OFFSET msg_yLx
	jmp WRITE_OUT
	
WRITE_OUT:
	call WriteString

	exit
main ENDP

end main