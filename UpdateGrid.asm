INCLUDE Irvine32.Inc
INCLUDE UpdateGrid.inc

MapToDisplay PROTO

.data
; "random" tiles generated after each move
tile_choice BYTE 3, 6, 0
index_count = 16  ; 16 DWORDS

.code
;-----------------------------------------------------
AddNewTile PROC
;
; Adds a new tile to the array grid and renders it on
; user's display.
; Receives: grid_array from main.
; Returns: grid_array with 1 new index filled in.
;-----------------------------------------------------
LOCAL randRow:BYTE, randCol:BYTE
     ; Get random index for dh_pos and set dh to one of the heights
     mov eax, 4
     call RandomRange

     ; Multiply by 4 since WORD array
     mov bl, 4
     mul bl
     mov randRow, al

     ; Get random index for dl_pos and set to one of the lengths
     mov eax, 4
     call RandomRange

     ; Multiply by 4 since WORD array
     mul bl
     mov randCol, al

     ; Map random num to index in grid.
     mov al, randRow
     mov bl, 4
     mul bl    ; Get corresponding index in 1D array

     ; Compute index in grid_array and store in bl.
     add al, randCol
     movzx ebx, al

     ; Get random index for tile_choice (0 or 1)
     mov eax, 2
     call RandomRange
     push eax

     ; Validate that random position in grid_array is empty
     mov esi, OFFSET grid_array        ; set esi to point to grid_array
     xor edi, edi                      ; Clear edi
     mov edi, [esi + ebx]              ; Get value at index in grid_array
     .IF edi != 0                      ; Check if empty
          call LinearProbe             ; Probe for a new, empty index
     .ENDIF

     ; Display random choice on game display and in array.
     display:
          pop eax                      ; Restore index of rand num
          mov al, [tile_choice + eax]  ; Store rand num
          mov [esi + ebx], eax         ; Store num in grid_array
          push eax                     ; save number to display
          
          ; Move to corresponding position in console
          call MapToDisplay

          ; Set text color to red
          mov eax, 0
          mov eax, red +(black*16)
          call setTextColor

          pop eax                      ; restore number to display
          call WriteDec                ; display to console

          ; Reset background/text color
          mov eax, 0
          mov eax, white +(black*16)
          call setTextColor
     ret
AddNewTile ENDP


;-----------------------------------------------------
LinearProbe PROC
;
; Linearly probes from a start index in DWORD grid_array
; until an empty index is found, or the array is full.
; Receives: 
; - grid_array from main, stored in esi
; - initial non-empty index, stored in ebx
; Returns: empty index in grid_array, stored in ebx
;-----------------------------------------------------
     mov ecx, index_count       ; Maximum possible probes

     ; Linearly probe for an empty index in the array.
     probe:
          add ebx, 4            ; Check next index
          mov ax, bx
          mov bl, 64            ; Mod by size of memory (16 * 4 WORDS)
          div bl                ; Use modulus to wrap around array

          ; Remainder (index) is stored in ah
          movzx ebx, ah         ; Move new index to check into ebx
          mov edi, [esi + ebx]  ; Get value at index
          .IF edi != 0
              loop probe        ; Probes 16 times in worst case.
          .ENDIF

     ; return index to place new tile.
     ret
LinearProbe ENDP


;-----------------------------------------------------
MapToDisplay PROC
;
; Sets the the dh and dl corresponding to an index in grid_array
; Receives: index of grid_array contained in ebx
; Returns: nothing
;-----------------------------------------------------
     ; Calculate dh value for console
     xor eax, eax
     mov eax, ebx
     mov ebx, 16
     div bl                       ; div by 16 to get row num.
     movzx ecx, al                ; quotient now holds row num
     mov dh, [dh_pos + ecx]

     ; Shift ah (remainder) into al to be used for finding column num
     shr ax, 8

     ; Calculate dl value for console
     mov ebx, 4
     div bl                       ; divide remainder by 4 to find col num
     xor ah, ah                   ; clear remainder to get quotient
     mov dl, [dl_pos + eax]

     call Gotoxy                  ; set height and width to write number
     ret
MapToDisplay ENDP


;-----------------------------------------------------
UpdateGrid PROC
;
; Handler for grid updates between player moves. Calls 
; AddNewTile to insert a new value into the grid array 
; and render it on the display.
; Receives: grid_array from main
; Returns: Increments tile_count in main
;-----------------------------------------------------

UpdateGrid ENDP
     call AddNewTile              ; add new tile to array and display
     inc tile_count               ; increment global tile count
     ret
END