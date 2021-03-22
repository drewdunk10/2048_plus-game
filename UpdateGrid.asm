INCLUDE Irvine32.Inc
INCLUDE UpdateGrid.inc

.data
; "random" tiles generated after each move
tile_choice BYTE 3, 9, 0
index_count = 16  ; 16 WORDS

.code
;-----------------------------------------------------
AddNewTile PROC
;
; Adds a new tile to the array grid.
; Receives: grid_array from main.
; Returns: grid_array with 1 new index filled in.
;-----------------------------------------------------
LOCAL randRow:BYTE, randCol:BYTE
     ; Get random index for dh_pos and set dh to one of the heights
     mov eax, 4
     call RandomRange
     ; mov dh, [dh_pos + eax]

     ; Multiply by 4 since WORD array
     mov bl, 4
     mul bl
     mov randRow, al

     ; Get random index for dl_pos and set to one of the lengths
     mov eax, 4
     call RandomRange
     ; mov dl, [dl_pos + eax]

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

     ; validate
     mov esi, OFFSET grid_array
     xor edi, edi                ; Clear edi
     mov edi, [esi + ebx]        ; Get value at index in grid_array
     .IF edi != 0                ; Check if empty
          mov ecx, index_count   ; Maximum possible probes
          jmp probe
     .ELSE
          jmp display
     .ENDIF

     probe:  ; TODO: FIX modulus
          add ebx, 4            ; Check next index
          mov ax, bx
          mov bl, 64            ; Mod by size of memory (16 * 4 WORDS)
          div bl                ; Use modulus to wrap around array

          ; Remainder stored in ah
          movzx ebx, ah            ; Move new index to check into ebx
          mov edi, [esi + ebx]
          .IF edi == 0
               jmp display
          .ELSE
              loop probe
          .ENDIF

     display:
          ; Display random choice on game display and in array.
          pop eax
          mov al, [tile_choice + eax]  ; Store rand num
          mov [esi + ebx], eax         ; Store num in grid_array

          push eax                     ; save number to display
          
          ; Get corresponding dh and dl positions for display
          mov eax, ebx
          mov ebx, 16
          div bl

          ; quotient now holds row num
          movzx ecx, al
          mov dh, [dh_pos + ecx]
          ; Shift ah into al to be used for finding column num
          shr ax, 8

          ; divide remainder by 4 to find col num
          mov ebx, 4
          div bl      ; mod remainder by 4
          xor ah, ah  ; clear remainder
          mov dl, [dl_pos + eax]

          ; Set height and width to write number.
          call Gotoxy

          pop eax                      ; restore number to display
          call WriteDec                ; game display (console)
          inc tile_count               ; increment global tile count

     ret
AddNewTile ENDP


;-----------------------------------------------------
UpdateGrid PROC
;
; Handler for grid updates. Inserts a new value into the grid
; array and renders it on the display.
; Receives: grid_array from main
; Returns: nothing
;-----------------------------------------------------

UpdateGrid ENDP
     call AddNewTile
     ret
END