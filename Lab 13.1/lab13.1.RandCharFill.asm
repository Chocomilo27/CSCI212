; Program Name:           RandCharFill.asm

; Program Description: Write a program that fills each screen cell of the 
;						console with a random character in a random color. 
;						Assign a 50% probability that the color of any 
;						character will be red.
; Author: Chad Dreier
; Date: 11/12/2015


INCLUDE Irvine32.inc

.data
outHandle HANDLE 0 ; standard output handle
consoleInfo CONSOLE_SCREEN_BUFFER_INFO <> ; CONSOLE_SCREEN_BUFFER_INFO structure
consoleCharSize DWORD ? ; number of chars in console
rChar BYTE ?
rColor BYTE ?
tc COORD <0,0>
cw dword ?

;writeconsoleattr function

.code
RandASCII PROTO,
	pChar: PTR DWORD  ;Pointer to Char Byte in memory
RandColor PROTO,
	pColor: PTR DWORD  ;Pointer to Color Byte in memory

main PROC 

  ; Get the console output handle:
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov outHandle,eax
  ; get console info
	invoke GetConsoleScreenBufferInfo,
	outHandle,
	ADDR consoleInfo

mov eax,0
mov ebx,0
mov ecx,0
mov edx,0

mov ax, consoleInfo.dwSize.X
mov bx, consoleInfo.dwSize.Y
mul bx
mov consoleCharSize, eax

mov ecx, consoleCharSize

Call Randomize

L1:

INVOKE RandASCII, ADDR rChar
INVOKE RandColor, ADDR rColor

; set x,y
	mov ax, tc.x
	mov bx, consoleInfo.dwSize.X
	cmp bx, ax
	ja X_COORD_OK
	mov tc.x, 0
	inc tc.y

	X_COORD_OK:
	mov ax, tc.y
	mov bx, consoleInfo.dwSize.Y
	cmp ax, bx
	ja Y_COORD_CAPPED



INVOKE WriteConsoleOutputAttribute,
    outHandle,
    ADDR rColor,
    1,
   tc,
   ADDR cw

INVOKE WriteConsoleOutputCharacter,
    outHandle,	; console output handle
    ADDR rChar,	; size of buffer
    1,	; first cell coordinates
   tc,	; pointer to buffer
   ADDR cw	; output count



inc tc.x

dec ecx; LOOP L1
jnz L1

Y_COORD_CAPPED:

; 4th char for red?
	


	exit
main ENDP


RandASCII PROC USES eax esi,
	pChar: PTR DWORD  ;Pointer to Char Byte in memory

	mov eax, 128
	Call RandomRange
	add eax, 20h

	mov esi, pChar
	mov [esi], al

	ret
RandASCII ENDP

RandColor PROC USES eax ebx esi,
	pColor: PTR DWORD  ;Pointer to Char Byte in memory

	mov eax, 0Fh
	Call RandomRange
	
	mov bl, 8h ; half of F
	cmp bl, al
	ja COLOR_OK

	mov al, 0Ch

COLOR_OK:
;and al,00001111b
	mov esi, pColor
	mov [esi], al

	ret
RandColor ENDP


end main