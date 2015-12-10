; Program Name:           Lab15.asm

; Program Description:	Write a program that generates all prime numbers between 2 and 1000, using 
;						 the Sieve of Eratosthenes method. You can find many articles that describe 
;						 the method for finding primes in this manner on the Internet. Display all 
;						 the prime values.
; Date: 12/03/2015

; HOW TO
; creates BYTE array and uses index number as the number. Value is used to 
; determine whether number is prime or not
;   marked: not prime - check next number
;   not marked: prime - mark its multiples as not prime

INCLUDE Irvine32.inc

.data
	start = 2d							; the first prime number to check
	max = 1000d							; the last prime number to check

	marked BYTE 1d						; value to use to mark a number
	markedList BYTE 999 DUP(0)			; array for numbers (0 based)

.code

; prototype for function that marks multiples of given number
markNumbers PROTO,
	nbr: WORD,
	mltpl: WORD,
	stop: word


main PROC 

; clear registers
	mov eax,0
	mov ebx,0
	mov ecx,0
	mov edx,0

; check numbers for prime
	; init registers
		mov dx, start					; start with 2 for first prime number
		mov cx, LENGTHOF markedList		; set loop counter to length of list (999)
		mov esi, OFFSET markedList		; set esi up to location of start of marked list
		add esi, edx					; move esi to location of first number (2)

CHECK_LOOP:
	; check if number^2 is greater than the max, if it is, any remaining not marked numbers are prime
	PUSHAD								; save registers
	mov ax, dx							; put dx in ax
	mul ax								; square it
	mov bx, max							; compare result to max
	cmp ax, bx
	POPAD								; restore registers
	ja CHECK_OVER						; skip checking the rest of the numbers if ax>bx

	; check if number is marked
	mov al, [esi]
	cmp al,0
	ja IS_MARKED

	; not marked / prime: mark its multiples
	INVOKE markNumbers, dx, dx, max

IS_MARKED:
	inc edx
	inc esi
	LOOP CHECK_LOOP


CHECK_OVER:

; output the prime numbers
	; init registers
		mov edx, 0						; clear edx
		mov dx, start
		mov cx, LENGTHOF markedList
		mov esi, OFFSET markedList
		add esi, edx

OUTPUT_LOOP:
	; check if number is marked, if not go to next number
	mov al, [esi]
	cmp al,0
	ja ISMARKED

	; not marked / prime: output edx
	mov eax, edx
	Call WriteDec
	Call Crlf

ISMARKED:
	inc edx
	inc esi
	LOOP OUTPUT_LOOP

	Call Crlf
	Call Crlf
	Call WaitMsg
	exit
main ENDP


;-----------------------------------------
markNumbers PROC USES eax ebx ecx edx esi,
	nbr: WORD,
	mltpl: WORD,
	stop: WORD
;-----------------------------------------
	movzx eax, nbr
	add ax, mltpl			; increment n
	movzx ebx, stop			; where to stop recursion
	cmp eax, ebx			; compare current n and stop, end recursion if above
	ja END_RECURSION
	
	; mark this array index
	mov esi, OFFSET markedList
	add esi, eax
	mov dl, marked
	mov [esi], dl

	; recursively check next multiple
	INVOKE markNumbers, ax, mltpl, stop

END_RECURSION:

	ret
markNumbers ENDP


end main