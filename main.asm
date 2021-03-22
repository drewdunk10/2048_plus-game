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

dir BYTE ?  ; Updated in UserPrompt
target_score DWORD 6561
current_score DWORD 0
tile_count DWORD 0

loseMsg	BYTE	"No moves left. Game over.", 0

.code
; Display the game board to user
printGrid PROC
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


main PROC PUBLIC
    call Randomize ; set seed

    call printGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid
    call UpdateGrid

    call UpdateGrid

    ; Lose condition
    .IF tile_count >= 16
         jmp game_over
    .ENDIF

    call UserPrompt

    game_over:
          ; Reset cursor to origin for error message.
          mov dx, 0
          call Gotoxy
          mov edx, OFFSET loseMsg
          call WriteString

          ; Move cursor below grid before exit.
          mov dx, 0
          mov dh, 20
          call Gotoxy

          invoke ExitProcess,0
main ENDP
end main