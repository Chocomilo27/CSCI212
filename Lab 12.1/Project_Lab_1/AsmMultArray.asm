; Program Name:           lab12.1.asm

; Program Description: 
; Write an assembly language subroutine that multiplies a doubleword array by an integer. 
; Use the supplied C++ test program that creates an array, passes it to the subroutine, 
; and prints the resulting timing values in comparison to a subroutine written in C++. Use 
; the C++ subroutine as a model for how to write the Assembly Language subroutine.
;
; Author: Chad Dreier
; Date: 11/5/2015

title MultArray Procedure      (AsmMultArray.asm)

.586
.model flat,C

AsmMultArray PROTO,
	srchVal:DWORD, arrayPtr:PTR DWORD, arraySize:DWORD

.code
;-----------------------------------------------
AsmMultArray PROC USES edi,
	mval:DWORD, arrayPtr:PTR DWORD, arraySize:DWORD
;
; Multiplies each element of an array by mval.
;-----------------------------------------------
	pushad				; save registers

	mov esi, arrayPtr	; set esi to address of array
	mov ecx, arraySize	; set ecx to size of array for loop

L1:
	mov eax, [esi]		; move value into eax of current array element
	mul mval			; multiply by value
	;mov [esi], eax		; not requirement, but would move lower half of result back into memory
	add esi, 4			; move esi

	LOOP L1				; loop

	popad				; return registers
	ret   
AsmMultArray ENDP

END

