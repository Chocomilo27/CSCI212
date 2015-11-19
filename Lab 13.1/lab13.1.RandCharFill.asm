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
RandASCII PROTO,									; function to generate a random ascii char
	pChar: PTR DWORD									;Pointer to Char Byte in memory

RandColor PROTO,									; function to generate a random color hex code
	pColor: PTR DWORD									;Pointer to Color Byte in memory

main PROC 

; Get the console output handle:
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov outHandle,eax

; Get console info
	invoke GetConsoleScreenBufferInfo,
	outHandle,
	ADDR consoleInfo

; Clear registers for easier debugging
	mov eax,0
	mov ebx,0
	mov ecx,0
	mov edx,0

; calculate how chars needed to fill console
	mov ax, consoleInfo.dwSize.X
	mov bx, consoleInfo.dwSize.Y
	mul bx
	mov consoleCharSize, eax

; set ecx/loop counter to char count
	mov ecx, consoleCharSize

; set random seed
	Call Randomize

; begin loop of writing chars to console
L1:

; get a random ascii char and a random color hex
	INVOKE RandASCII, ADDR rChar
	INVOKE RandColor, ADDR rColor

; set x,y
	mov ax, tc.x
	mov bx, consoleInfo.dwSize.X
	cmp bx, ax
	ja X_COORD_OK

	; increment row and set col to 0 because at end of row
	mov tc.x, 0
	inc tc.y

	X_COORD_OK:
	mov ax, tc.y
	mov bx, consoleInfo.dwSize.Y
	cmp ax, bx
	ja Y_COORD_CAPPED


; set color
	INVOKE WriteConsoleOutputAttribute,
		outHandle,		; console output handle
		ADDR rColor,	; location in memory of char
		1,				; first cell coordinates
		tc,				; pointer to buffer
		ADDR cw			; output count

; write char at x,y
	INVOKE WriteConsoleOutputCharacter,
		outHandle,		; console output handle
		ADDR rChar,		; location in memory of char
		1,				; first cell coordinates
		tc,				; pointer to buffer
		ADDR cw			; output count


; increment col
	inc tc.x

dec ecx
jnz L1		; using loop was blowing up

Y_COORD_CAPPED:
; over last row, exit

	exit
main ENDP


RandASCII PROC USES eax esi, ; return random ascii char - limit to just ascii char number range
	pChar: PTR DWORD  ;Pointer to Char Byte in memory
	
	mov eax, 128
	Call RandomRange
	add eax, 20h

	mov esi, pChar
	mov [esi], al

	ret
RandASCII ENDP

RandColor PROC USES eax ebx esi, ; return random color - force 50% chance that color is red
	pColor: PTR DWORD  ;Pointer to Char Byte in memory

	mov eax, 0Fh
	Call RandomRange
	
	mov bl, 8h ; half of F for 50% red
	cmp bl, al
	ja COLOR_OK

	mov al, 0Ch

COLOR_OK:
	mov esi, pColor
	mov [esi], al

	ret
RandColor ENDP


end main