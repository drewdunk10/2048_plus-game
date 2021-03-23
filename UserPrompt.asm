INCLUDE Irvine32.Inc
INCLUDE UserPrompt.inc

.data
dirPrompt	BYTE "Enter the direction (ASWD): ", 0
errorMsg	BYTE	"Invalid Move, must be of one of ASWD. Try again: ", 0
clearPrompt BYTE 50 DUP(" "), 0

.code
;-----------------------------------------------------
InputTheDir PROC
;
; Prompts user for a direction. Saves the char in dir (if valid).
; Receives: nothing
; Returns: sets dir in main
;-----------------------------------------------------
	pushad
	mov edx, OFFSET dirPrompt; display a prompt
	call	WriteString
	call	ReadChar         	; Input the charater.
	; call WriteChar			; Display direction choice.
	mov dir, al			; Save the direction in dir.
	call ValidateInput		; Continue prompt until valid input.
	popad
	ret
InputTheDir ENDP

;-----------------------------------------------------
ValidateInput PROC
;
; Compares input with one of the direction choices. If invalid,
; prompt user for another character until valid.
; Receives: dir points to initial direction choice.
; Returns: nothing
;-----------------------------------------------------
	mov edx, OFFSET errorMsg
	push edx

	; compare character with valid choices
	mov ebx, 0
	.WHILE ebx == 0
		INVOKE Str_ucase, ADDR dir
		.IF dir == 'A' || dir == 'S' || dir == 'D' || dir == 'W'
			mov ebx, 1
		.ELSE
			mov dx, 0
			call Gotoxy

			pop edx			; Restore error message.
			call WriteString
			call	ReadChar       ; Input the charater.
			mov dir, al
			; call WriteChar		; Display direction choice.
			push edx			; Save message in case of another iteration.
		.ENDIF
	.ENDW

	pop edx
	ret
ValidateInput ENDP

;-----------------------------------------------------
UserPrompt PROC
;
; Handler for user input. Calls methods to receive, validate,
; and display user input.
; Receives: nothing
; Returns: dir is set to a valid choice
;-----------------------------------------------------
	; Get user input and validate.
	mov dx, 0
	call Gotoxy
	call InputTheDir
	
	; Clear the prompt.
	mov dx, 0
	call Gotoxy
	mov edx, OFFSET clearPrompt
	call WriteString

	ret 
UserPrompt ENDP

END ; Notice that this is only END, not END main