; Program Name:           DrawBox.asm

; Program Description:	Draw a box on the screen using line-drawing characters 
;							from the character set listed on the inside back cover 
;							of the book. Hint: Use the WriteConsoleOutputCharacter 
;							function.
; Date: 11/19/2015


INCLUDE Irvine32.inc

.data
boxWidth WORD 20d									; width of box
boxHeight WORD 10d									; height of box
outHandle HANDLE 0									; standard output handle
consoleInfo CONSOLE_SCREEN_BUFFER_INFO <>			; CONSOLE_SCREEN_BUFFER_INFO structure
boxCharSize DWORD ?									; number of chars needed to write box
tc COORD <0,0>										; COORD structure
cw dword ?											; output count - needed for WriteConsole functions
vChar BYTE 7Ch										; vertical character for box
hChar BYTE 02Dh										; horizontal bar for box


.code
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

; make sure width and height are not larger than console
	mov ax, boxWidth
	mov bx, consoleInfo.dwSize.X
	cmp bx, ax
	ja WIDTH_OK

	mov boxWidth, bx

	WIDTH_OK:
	mov ax, boxHeight
	mov bx, consoleInfo.dwSize.Y
	cmp bx, ax
	ja HEIGHT_OK

	mov boxHeight, bx

	HEIGHT_OK:

; calculate how many chars needed to draw box
	mov ax, boxWidth
	mov bx, boxHeight
	mul bx
	mov boxCharSize, eax

; decrement w & h for zero based
	dec boxWidth
	dec boxHeight

; set ecx/loop counter to char count
	mov ecx, boxCharSize

; begin loop of writing chars to console
ROWLOOP:
	; set x
		mov ax, tc.x
		mov bx, boxWidth
		cmp bx, ax
		jae X_COORD_OK

		; increment row and set col to 0 because at end of row
		mov tc.x, 0
		inc tc.y

	X_COORD_OK:
	
	; check if row is outer row (first or last row)
		mov ax, tc.y
		mov bx, 0
		cmp ax, bx
		je WRITE_HCHAR
			
		mov ax, tc.y
		mov bx, boxHeight
		cmp bx, ax
		je WRITE_HCHAR
			
		jmp NOT_OUTER_ROW

		WRITE_HCHAR:
		; write char at x,y which is an outer row (each cell gets horizontal char)
			push ecx
			INVOKE WriteConsoleOutputCharacter,
				outHandle,		; console output handle
				ADDR hChar,		; location in memory of char
				1,				; first cell coordinates
				tc,				; pointer to buffer
				ADDR cw			; output count
			pop ecx

			inc tc.x			; increment x position
			dec ecx				; dec ecx
			jnz ROWLOOP			; jump if not zero
			jmp DONE			; or jump to end

		NOT_OUTER_ROW:

	; check if column is outer column (first or last column)
		mov ax, tc.x
		mov bx, 0
		cmp ax, bx
		je WRITE_VCHAR
		
		mov ax, tc.x
		mov bx, boxWidth
		cmp bx, ax
		je WRITE_VCHAR
			
		jmp NOT_OUTER_COL
		
		WRITE_VCHAR:
		; write char at x,y which is an outer column (gets vertical char)
			push ecx
			INVOKE WriteConsoleOutputCharacter,
				outHandle,		; console output handle
				ADDR vChar,		; location in memory of char
				1,				; first cell coordinates
				tc,				; pointer to buffer
				ADDR cw			; output count
			pop ecx
			inc tc.x			; increment x position
			dec ecx				; dec ecx
			jnz ROWLOOP			; jump if not zero
			jmp DONE			; or jump to end

	; not outer row or outer col
		NOT_OUTER_COL:

		inc tc.x			; increment x position
		dec ecx				; dec ecx
		jnz ROWLOOP			; jump if not zero
DONE:

	exit
main ENDP

end main