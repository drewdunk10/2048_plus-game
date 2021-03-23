INCLUDE Irvine32.Inc
INCLUDE UserPrompt.inc  ; also needs header file to recognize UserPrompt call
INCLUDE UpdateGrid.inc

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
target_score DWORD 6561
current_score DWORD 0
tile_count DWORD 0

; Text for scoreboard
score1 BYTE "Current Score: ", 0
score2 BYTE "Target Score: ", 0
score3 BYTE "Tile Count: ", 0
score4 BYTE "Last Move: ", 0

loseMsg	BYTE	"No moves left. Game over.", 0
winMsg    BYTE "Target score reached. You win!", 0

.code
;-----------------------------------------------------
printGrid PROC
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

printGrid ENDP


;-----------------------------------------------------
updateScoreBoard PROC
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

     mov eax, target_score
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
updateScoreBoard ENDP


main PROC PUBLIC
    call Randomize                 ; Set seed.
    call printGrid                 ; Display empty board.

    ; Initialize grid with two tiles. TODO: Allow user to set?
    call UpdateGrid
    call UpdateGrid
    call updateScoreBoard

    ; Main game loop
    .WHILE (tile_count < 16)
          call UserPrompt          ; Prompts user for a direction to move.
          ; call GridMove          ; Executes move and shifts tiles.
          
          ; Check win condition before adding a new tile.
          mov eax, current_score
          .IF (eax >= target_score)
               jmp win
          .ENDIF

          call UpdateGrid          ; Adds a random tile after a user move.
          call updateScoreBoard    ; Updates/Renders game variables on display.
    .ENDW

    lose:
          ; Move cursor above grid for lose message.
          mov dx, 0
          mov dh, 4
          call Gotoxy
          mov edx, OFFSET loseMsg
          call WriteString
          jmp _exit

     win:
          ; Move cursor above grid for win message.
          mov dx, 0
          mov dh, 4
          call Gotoxy
          mov edx, OFFSET winMsg
          call WriteString

     ; Move cursor below grid before exit.
     _exit:
          call updateScoreBoard    ; Final update before exit.
          mov dx, 0
          mov dh, 20
          call Gotoxy

          invoke ExitProcess,0
main ENDP
end main