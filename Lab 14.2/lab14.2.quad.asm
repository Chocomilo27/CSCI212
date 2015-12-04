; Program Name:           Lab14.2.asm

; Program Description:	Prompt the user for coefficients a, b, and c of a polynomial in the 
;						 form ax2+bx +c=0. Calculate and display the real roots of the polynomial
;						 using the quadratic formula. If any root is imaginary, display an 
;						 appropriate message.
; Date: 12/03/2015


INCLUDE Irvine32.inc

.data
	;strings for user prompt/response
		str1 BYTE "Coefficient A for Ax^2 + Bx + C: ",0
		str2 BYTE "Coefficient B for Ax^2 + Bx + C: ",0
		str3 BYTE "Coefficient C for Ax^2 + Bx + C: ",0
		str4 BYTE "This polynomial has at least one imaginary root",0
		str5 BYTE "Root 1: ",0
		str6 BYTE "Root 2: ",0

	; variables to hold the coefficients provided from the user
		coeffA REAL8 ?
		coeffB REAL8 ?
		coeffC REAL8 ?

	; misc variables to pop/push stack since cannot push literals to stack
		two REAL8 2.0
		four REAL8 4.0
		zero REAL8 0.0
		junk REAL8 0.0
	
	; store for sqrt(B^2 - 4ac)
		sqrt REAL8 ?


.code
main PROC 

	; init
		call Clrscr								; clear output
		finit									; init floating point
		call getCoefficients					; get data from user

	; calc expression under radical (radicand): B^2 - 4ac
		fld coeffB								; copy B to top of stack
		fmul ST(0),ST(0)						; square B by multiplying it by itself		B^2
		fld four								; copy 4 to top of stack
		fmul coeffA								; multiply top of stack by A				4*A
		fmul coeffC								; multiply top of stack by C				*C
		fsub									; subtract stack(1) by top of stack and
												; store in top of stack						B^2 - 4ac
											
	; make sure radicand is positive	
		fld zero								; copy 0 to top of stack
		fcomi ST(0),ST(1)						; compare zero and radicand
		ja IMAGINARY_ROOT						; radicand is negative, go to imaginary root response

	; calc square root of radicand
		fstp junk								; get rid of zero value on top of stack
		fsqrt									; square root top of stack
		fstp sqrt								; save sqrt

	; calc first root
		; quotient: -B+sqrt | -B+sqrt
			fld coeffB							; move B to stack
			fchs								; change sign
			fadd sqrt							; -B + sqrt
		
		; divisor: 2a
			fld coeffA							; move A to stack
			fmul two							; multiply by 2

		fdivp ST(1),ST(0)						; DIVIDE

		; show first answer
			mov edx, OFFSET str5				; move offset of prompt into EDX register
			call WriteString					; Call Irvine32 WriteString function
			call WriteFloat						; Use Irvine32 WriteFloat function to write top of stack to console
			call Crlf							; Use Irvine32 Crlf function to write new line to console

	; calc second root
		; quotient: -B-sqrt | -B-sqrt
			fld coeffB							; move B to stack
			fchs								; change sign
			fsub sqrt							; -B + sqrt
		
		; divisor: 2a
			fld coeffA							; move A to stack
			fmul two							; multiply by 2

		fdivp ST(1),ST(0)						; DIVIDE

		; show first answer
			mov edx, OFFSET str6				; move offset of prompt into EDX register
			call WriteString					; Call Irvine32 WriteString function
			call WriteFloat						; Use Irvine32 WriteFloat function to write top of stack to console
			call Crlf							; Use Irvine32 Crlf function to write new line to console


	JMP NORMAL_EXIT

IMAGINARY_ROOT:
	mov edx, OFFSET str4
	call WriteString

NORMAL_EXIT:
	Call Crlf
	Call Crlf
	Call WaitMsg
	exit
main ENDP


;-----------------------------------------
getCoefficients PROC
;-----------------------------------------

	; ask user for A
		mov edx, OFFSET str1					; move offset of prompt into EDX register
		call WriteString						; Call Irvine32 WriteString function
		call ReadFloat							; Use Irvine32 ReadFloat function to get coefficient
		fstp coeffA								; read response from stack and store in variable

	; ask user for B
		mov edx, OFFSET str1					; move offset of prompt into EDX register
		call WriteString						; Call Irvine32 WriteString function
		call ReadFloat							; Use Irvine32 ReadFloat function to get coefficient
		fstp coeffB								; read response from stack and store in variable

	; ask user for C
		mov edx, OFFSET str1					; move offset of prompt into EDX register
		call WriteString						; Call Irvine32 WriteString function
		call ReadFloat							; Use Irvine32 ReadFloat function to get coefficient
		fstp coeffC								; read response from stack and store in variable

	ret
getCoefficients ENDP


end main