; Program Name:           lab12.2.asm

; Program Description: 
; Write an assembly language subroutine that receives the offsets of three arrays, 
; all of equal size.It adds the second and third arrays to the values in the first 
; array. When it returns, the first arrayhas all new values. Use the supplied test 
; program in C++ that creates an array, passes it to the subroutine, and prints the 
; contents of the first array.
;
; Author: Chad Dreier
; Date: 11/5/2015

; Sum Three Arrays								 (sumarrays.asm)

COMMENT !
Assembly language subroutine that receives the offsets of three arrays, 
all of equal size. It adds the second and third arrays to the values in 
the first array. When it returns, the first array has all new values. 
!


.586
.model flat,C

SumThreeArrays PROTO,
	array1:PTR DWORD, array2:PTR DWORD, 
	array3:PTR DWORD, arraySize:DWORD

.code
;-----------------------------------------------
SumThreeArrays PROC USES eax ebx esi,
	array1:PTR DWORD, array2:PTR DWORD, 
	array3:PTR DWORD, arraySize:DWORD
;-----------------------------------------------
	LOCAL sz:BYTE		; local sz for jump
	mov sz, 4					; size of each iteration jump
	mov ecx, arraySize			; set ecx to size of arrays for loop
	
L1:
	mov eax, arraySize			; move array size into eax
	sub eax, ecx				; subtract whats left
	mul sz						; multiply by 4 to know how much to jump
	
	mov esi, array1				; set esi to start of array 1
	mov ebx, [esi+eax]			; move value of esi+jump into ebx
	
	mov esi, array2				; set esi to start of array 2
	add ebx, [esi+eax]			; add value of esi+jump to ebx

	mov esi, array3				; set esi to start of array 3
	add ebx, [esi+eax]			; add value of esi+jump to ebx

	mov esi, array1				; set esi to start of array 1
	mov [esi+eax], ebx			; move value of ebx into esi+jump

	LOOP L1

	ret  
SumThreeArrays ENDP

END

