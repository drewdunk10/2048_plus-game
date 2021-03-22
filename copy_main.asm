INCLUDE Irvine32.inc
INCLUDE UserPrompt.inc  ; also needs header file to recognize UserPrompt call

.data
; Use these rows to construct the grid.
divider BYTE 21 DUP("-"), 0
block_row BYTE "|    |    |    |    |", 0

; Array to hold values in game grid
grid_array DWORD 16 DUP(0), 0

; Number positions for display grid:
dh_pos BYTE 6, 8, 10, 12, 0
dl_pos BYTE 1, 6, 11, 16, 0

; "random" tiles generated after each move
tile_choice BYTE 3, 9, 0

dir BYTE ?  ; Updated in UserPrompt
target_score DWORD 6561
current_score DWORD 0
tile_count DWORD 0

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


addNewTile PROC
LOCAL randRow:BYTE, RandCol:BYTE
     ; Get random index for dh_pos and set dh to one of the heights
     mov eax, 4
     call RandomRange
     mov randRow, al
     mov dh, [dh_pos + eax]

     ; Get random index for dl_pos and set to one of the lengths
     mov eax, 4
     call RandomRange
     mov randCol, al
     mov dl, [dl_pos + eax]
     
     ; Set height and width to write number.
     ;mov dh, [dh_pos + randRow]
     ;mov dl, [dl_pos + randCol]
     call Gotoxy

     ; Map random num to index in grid.
     mov al, randRow
     mov bl, 4
     mul bl

     ; Compute index in grid_array and store in bl.
     add al, randCol
     mov bl, al

     ; Get random index for tile_choice (0 or 1)
     mov eax, 2
     call RandomRange

     ; Display random choice on game display and in array.
     mov al, [tile_choice + eax]
     mov esi, grid_array
     mov [esi + ebx], eax ; grid_array
     call WriteDec        ; game display (console)
     inc tile_count       ; increment global tile count

     ret
addNewTile ENDP


main PROC PUBLIC
    call Randomize ; set seed

    call printGrid
    call addNewTile

    call UserPrompt

    ; Reset cursor to origin.
    mov dx, 0
    call Gotoxy

    invoke ExitProcess,0
main ENDP
end main