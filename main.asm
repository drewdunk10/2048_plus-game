INCLUDE Irvine32.Inc
INCLUDE UserPrompt.inc  ; also needs header file to recognize UserPrompt call
INCLUDE UpdateGrid.inc
INCLUDE GridMove.inc    ; sliding tiles

.data
; Use these rows to construct the grid.
divider BYTE 21 DUP("-"), 0
block_row BYTE "|    |    |    |    |", 0

; Array to hold values in game grid
grid_array DWORD 16 DUP(0), 0

; Number positions for display grid:
dh_pos BYTE 6, 8, 10, 12, 0
dl_pos BYTE 1, 6, 11, 16, 0

; Values used for scoreboard
dir BYTE ?               ; Set in UserPrompt
target_tile DWORD 3072
current_max DWORD 0
current_score DWORD 0
tile_count DWORD 0

; Text for scoreboard
score1 BYTE "Current Score: ", 0
score2 BYTE "Target Tile: ", 0
score3 BYTE "Tile Count: ", 0
score4 BYTE "Last Move: ", 0

startMsg BYTE "Choose a multiple for the game (1-9): ", 0
errMsg BYTE "Please enter a number 1-9: ", 0
loseMsg BYTE "No moves left. Game over. Your biggest tile: ", 0
winMsg  BYTE " tile reached. You win!", 0

multiple BYTE 1
tile_choice BYTE 1, 2, 0  ; "random" tiles generated after each move

; Flag to test for a valid move
moveFlag BYTE 0

.code
;-----------------------------------------------------
PrintGrid PROC
;
; Prints the empty game board in the console.
; Receives: divider and block_row BYTE arrays
; Returns: nothing
;-----------------------------------------------------
     ;Gotoxy start position for board
     mov dh, 5
     mov dl, 0
     mov ecx, 9
     mov bl, 2

     build_row:
          ; Move to next row.
          call Gotoxy
          inc dh   ; move start row for next loop
          push edx ; save value since WriteString also uses edx

          ; mov counter value for modulus.
          mov ax, cx
          div bl

          ; Check remainder for even or odd row.
          .IF(ah == 1)
               mov edx, OFFSET divider
          .ELSE
               mov edx, OFFSET block_row
          .ENDIF
          
          ; Write the row to the console.
          call WriteString
          pop edx  ; restore next row position.

          ; Loop to next row.
          loop build_row
          ret

PrintGrid ENDP


;-----------------------------------------------------
UpdateScoreBoard PROC
;
; Re-displays each of the game variables on the console.
; Receives: values of current_score, target_score, 
; tile_count, and dir.
; Returns: nothing
;-----------------------------------------------------
     mov dh, 16
     mov dl, 0
     call Gotoxy

     mov eax, current_score
     mov edx, OFFSET score1
     call WriteString
     call WriteDec
     call Crlf

     mov eax, target_tile
     mov edx, OFFSET score2
     call WriteString
     call WriteDec
     call Crlf

     mov eax, tile_count
     mov edx, OFFSET score3
     call WriteString
     call WriteDec
     call Crlf

     movzx eax, dir
     mov edx, OFFSET score4
     call WriteString
     call WriteChar
     call Crlf

     ret 
UpdateScoreBoard ENDP

;-----------------------------------------------------
CheckMoves PROC USES ecx ebx
;
; Checks a filled grid of tiles for any possible moves
; remaining.
; Returns: 0 if no moves remaining and 1 otherwise by
; storing it in EAX
;-----------------------------------------------------
LOCAL row_first:DWORD
    mov esi, OFFSET grid_array      ; Pointer to game board grid array.
    mov ecx, 0                      ; Current index.
    mov row_first, 0                ; Stores first index in row.
    .WHILE (ecx <= 60)  ; 15 * 4 = 60 (last index in grid_array).
        ; Get index of row first.
        mov ax, cx
        mov bl, 16            ; Mod by 16 to check if first element in row.
        div bl                ; If it is the first element don't check left.

         ; Remainder is stored in ah.
        .IF ah == 0
            mov row_first, ecx
        .ENDIF
        
        ; Move value at current index to ebx.
        mov ebx, [esi + ecx]

        ; If first row, don't check up.
        cmp ecx, 12
        jle skip_up
        ; Check slide up possibility.
        cmp ebx, [esi + ecx - 16]
        je possible
    skip_up:
        ; If last row, don't check down.
        mov eax, ecx
        add eax, 16
        cmp eax, 60
        ja skip_down
        ; Check slide down possibility.
        cmp ebx, [esi + ecx + 16]
        je possible
    skip_down:
        ; If first column, don't check left.
        cmp ecx, row_first
        je skip_left
        ; Check slide left possibility.
        cmp ebx, [esi + ecx - 4]
        je possible
    skip_left:
        ; If last column, don't check right.
        mov eax, row_first
        add eax, 12
        cmp ecx, eax
        je skip_right
        ; Check slide right possibility.
        cmp ebx, [esi + ecx + 4]
        je possible
    skip_right:
        ; Move to next index in grid_array.
        add ecx, 4
    .ENDW
    ; Return 0 in eax.
    mov eax, 0
    ret
  possible:
    ; Return 1 in eax.
    mov eax, 1
    ret
CheckMoves ENDP

main PROC PUBLIC
    call Randomize                 ; Set seed.

    ; Ask user to select a starting multiple
    mov eax, 0
    mov edx, OFFSET startMsg
    call WriteString
    read:  
       call ReadDec
       cmp eax, 9
       jle valid

       mov  edx, OFFSET errMsg
       call WriteString
       jmp  read

    valid:
       mov  multiple, al
       call ClrScr

    ; Calculate tile to win
    mov bx, 1024
    mul bx
    mov target_tile, eax

    ; Initialize tile choices
    mov al, multiple
    mov tile_choice[0], al
    add al, al
    mov tile_choice[1], al

    call PrintGrid                 ; Display empty board.

    ; Initialize grid with two tiles.
    call UpdateGrid
    call UpdateGrid
    call UpdateScoreBoard

    ; Main game loop
    mov eax, target_tile
    .WHILE (current_max < eax)
          push eax

          prompt:
          call UserPrompt         ; Prompts user for a direction to move.
          call GridMove           ; Executes move and shifts tiles.

          ; Check valid move flag
          cmp moveFlag, 0         ; Check if no slides happened
          je prompt               ; If no tiles slid, ask user for input again
          mov moveFlag, 0
          
          ; Check win condition before adding a new tile.
          mov eax, current_max

          call UpdateGrid          ; Adds a random tile after a user move.
          call UpdateScoreBoard    ; Updates/Renders game variables on display.

          pop eax
          .IF (tile_count >= 16)
                call CheckMoves
                cmp eax, 0
                je lose
          .ENDIF

    .ENDW

     win:
          ; Move cursor above grid for win message.
          mov dx, 0
          mov dh, 4
          call Gotoxy
          mov eax, target_tile
          call WriteDec
          mov edx, OFFSET winMsg
          call WriteString
          jmp _exit
    lose:
          ; Move cursor above grid for lose message.
          mov dx, 0
          mov dh, 4
          call Gotoxy
          mov edx, OFFSET loseMsg
          call WriteString
          mov eax, current_max
          call WriteDec

     ; Move cursor below grid before exit.
     _exit:
          call UpdateScoreBoard    ; Final update before exit.
          mov dx, 0
          mov dh, 20
          call Gotoxy

          invoke ExitProcess,0
main ENDP
end main