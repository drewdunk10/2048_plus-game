INCLUDE Irvine32.inc
INCLUDE GridMove.inc
INCLUDE UpdateGrid.inc

MapToDisplay PROTO

.data
blank BYTE "    ", 0

.code
slideUp PROC
LOCAL base:DWORD, start:DWORD
    ; Pointer to grid array.
    mov esi, OFFSET grid_array
    mov base, 0     ; track base index (first available spot to slide to).

    mov ecx, 4      ; columns to check. 
  lp:
    ; Save beginning of base pointer.
    mov ebx, base
    push ebx
    ; Starting top left, slide up for each column.
    
    
    ; Setting start index as block below base.
    mov eax, base
    add eax, 16
    mov start, eax

    ; Column bottom index.
    mov edx, ebx
    add edx, 48

    ; Loop through columns and slide tiles up for each.
    .WHILE (start <= edx)
        ; Store end index value.
        push edx

        mov eax, start
        mov ebx, base
        .IF(DWORD PTR [esi + eax] > 0)
             inc moveFlag
             mov edx, [esi + eax]
             ; If base and start tiles are equal.
            .IF([esi + ebx] == edx)
                ; Combine tile to base pos tile.
                add [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0

                ; Make the block below base the new base.
                add base, 16

                ; Decrement tile count and increase score
                jmp updt_scr
             ; If base is empty spot.
            .ELSEIF(DWORD PTR [esi + ebx] == 0)
                ; Move tile to base pos.
                mov [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0
             
            .ELSE
                ; Make the block below base the new base.
                add base, 16

                ; Move tile to pos below base if not already
                cmp base, eax
                jne move_before

                ; If invalid move, undo increment
                dec moveFlag
            .ENDIF

        .ENDIF
        back:
        ; Get end index.
        pop edx
        ; Move to row below.
        add start, 16
    .ENDW

    ; Fetch base and increment to next column.
    pop ebx
    add ebx, 4
    mov base, ebx
    
    loop lp

    ret
  updt_scr:
     dec tile_count
     add edx, edx
     .IF(edx > current_max)
          mov current_max, edx
     .ENDIF
     add current_score, edx
     jmp back
  move_before:
     ; Move tile to pos below base.
     mov DWORD PTR [esi + eax], 0
     mov [esi + ebx + 16], edx
     jmp back
slideUp ENDP

slideDown PROC
LOCAL base:DWORD, start:DWORD
    ; Pointer to grid array.
    mov esi, OFFSET grid_array
    mov base, 48     ; track base index (first available spot to slide to).

    mov ecx, 4      ; columns to check. 
  lp:
    ; Save beginning of base pointer.
    mov ebx, base
    push ebx
    ; Starting bottom left, slide down for each column.
    
    
    ; Setting start index as block above base.
    mov eax, base
    sub eax, 16
    mov start, eax

    ; Column top index.
    mov edx, ebx
    sub edx, 48

    ; Loop through columns and slide tiles down for each.
    .WHILE (start >= edx)
        ; Store end index value.
        push edx

        mov eax, start
        mov ebx, base
        .IF(DWORD PTR [esi + eax] > 0)
             inc moveFlag
             mov edx, [esi + eax]
             ; If base and start tiles are equal.
            .IF([esi + ebx] == edx)
                ; Combine tile to base pos tile.
                add [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0

                ; Make the block above base the new base.
                sub base, 16

                ; Decrement tile count and increase score
                jmp updt_scr   
             ; If base is empty spot.
            .ELSEIF(DWORD PTR [esi + ebx] == 0)
                ; Move tile to base pos.
                mov [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0
             
            .ELSE
                ; Make the block above base the new base.
                sub base, 16

                cmp base, eax

                ; Move tile to pos above base.
                jne move_before
              
                dec moveFlag
            .ENDIF

        .ENDIF
        back:
        ; Get end index.
        pop edx
        ; Check to avoid negative number.
        .IF (start == edx)
            jmp nxt
        .ENDIF
        ; Move to row above.
        sub start, 16
    .ENDW
  nxt:
    ; Fetch base and increment to next column.
    pop ebx
    add ebx, 4
    mov base, ebx
    
    loop lp

    ret
  updt_scr:
     dec tile_count
     add edx, edx
     .IF(edx > current_max)
          mov current_max, edx
     .ENDIF
     add current_score, edx
     jmp back
  move_before:
     ; Move tile to pos above base.
     mov DWORD PTR [esi + eax], 0
     mov [esi + ebx - 16], edx
     jmp back
slideDown ENDP

slideLeft PROC
LOCAL base:DWORD, start:DWORD
    ; Pointer to grid array.
    mov esi, OFFSET grid_array
    mov base, 0     ; track base index (first available spot to slide to).

    mov ecx, 4      ; rows to check. 
  lp:
    ; Save beginning of base pointer.
    mov ebx, base
    push ebx
    ; Starting top left, slide left for each column.
    
    
    ; Setting start index as block right of base.
    mov eax, base
    add eax, 4
    mov start, eax

    ; Column rightmost index.
    mov edx, ebx
    add edx, 12

    ; Loop through rows and slide tiles left for each.
    .WHILE (start <= edx)
        ; Store end index value.
        push edx

        mov eax, start
        mov ebx, base
        .IF(DWORD PTR [esi + eax] > 0)
             inc moveFlag
             mov edx, [esi + eax]
             ; If base and start tiles are equal.
            .IF([esi + ebx] == edx)
                ; Combine tile to base pos tile.
                add [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0

                ; Make the block right of base the new base.
                add base, 4

                ; Decrement tile count and increase score
                jmp updt_scr
            
             ; If base is empty spot.
            .ELSEIF(DWORD PTR [esi + ebx] == 0)
                ; Move tile to base pos.
                mov [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0
             
            .ELSE
                ; Make the block right of base the new base.
                add base, 4

                cmp base, eax

                ; Move tile to pos right base.
                jne move_before

                dec moveFlag
            .ENDIF
        .ENDIF
        back:
        ; Get end index.
        pop edx

        ; Move to column right.
        add start, 4
    .ENDW
 
    ; Fetch base and increment to next row.
    pop ebx
    add ebx, 16
    mov base, ebx
    
    loop lp

    ret
  updt_scr:
     dec tile_count
     add edx, edx
     .IF(edx > current_max)
          mov current_max, edx
     .ENDIF
     add current_score, edx
     jmp back
  move_before:
     mov DWORD PTR [esi + eax], 0
     mov [esi + ebx + 4], edx
     jmp back
slideLeft ENDP

slideRight PROC
LOCAL base:DWORD, start:DWORD
    ; Pointer to grid array.
    mov esi, OFFSET grid_array
    mov base, 12     ; track base index (first available spot to slide to).

    mov ecx, 4      ; rows to check. 
  lp:
    ; Save beginning of base pointer.
    mov ebx, base
    push ebx
    ; Starting top right, slide right for each column.
    
    
    ; Setting start index as block left of base.
    mov eax, base
    sub eax, 4
    mov start, eax

    ; Column leftmost index.
    mov edx, ebx
    sub edx, 12

    ; Loop through rows and slide tiles right for each.
    .WHILE (start >= edx)
        ; Store end index value.
        push edx

        mov eax, start
        mov ebx, base
        .IF(DWORD PTR [esi + eax] > 0)
             inc moveFlag
             mov edx, [esi + eax]
             ; If base and start tiles are equal.
            .IF([esi + ebx] == edx)
                ; Combine tile to base pos tile.
                add [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0

                ; Make the block left of base the new base.
                sub base, 4

                ; Decrement tile count and increase score
                jmp updt_scr
             ; If base is empty spot.
            .ELSEIF(DWORD PTR [esi + ebx] == 0)
                ; Move tile to base pos.
                mov [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0
             
            .ELSE
                ; Make the block left of base the new base.
               sub base, 4
               cmp base, eax

               ; Move tile to pos left base.
               jne move_before

               ; If invalid move, decrement the flag
               dec moveFlag
            .ENDIF

        .ENDIF
        back:
        ; Get end index.
        pop edx
        ; Check to avoid negative number.
        .IF (start == edx)
            jmp nxt
        .ENDIF
        ; Move to column left.
        sub start, 4
    .ENDW
  nxt:
    ; Fetch base and increment to next row.
    pop ebx
    add ebx, 16
    mov base, ebx
    
    loop lp

    ret
  updt_scr:
    dec tile_count
    add edx, edx
    .IF(edx > current_max)
          mov current_max, edx
    .ENDIF
    add current_score, edx
    jmp back
  move_before:
     mov DWORD PTR [esi + eax], 0
     mov [esi + ebx - 4], edx
     jmp back
slideRight ENDP

;-----------------------------------------------------
SetColor PROC USES eax ebx ecx
;
; Takes value of tile and sets text to the appropriate
; color that corresponds to that tile.
; Receives: value of tile in EAX.
; Returns: nothing
;-----------------------------------------------------
    mov ecx, 0      ; Track number of divisions.

    ; Initial division by base multiple.
    mov bl, 3
    div bl

    ; Future divisions will be by 2.
    mov bl, 2
    .WHILE (al > 1)
        ; Clear remainder to only use quotient.
        xor ah, ah
        div bl

        inc ecx
    .ENDW

    ; Mod by 15 to use all available colors.
    mov eax, ecx
    mov bl, 15      ; Mod by 16 to check if first element in row.
    div bl                ; If it is the first element don't check left.

    ; Remainder is stored in ah, which is the color to use.
    shr ax, 8
    inc al
    xor ah, ah

    call setTextColor

    ret
SetColor ENDP

;-----------------------------------------------------
DisplayMove PROC
;
; Re-displays each index of grid_array on the console
; after a move is performed.
; Receives:
;    - external: grid_array
;    - global: blank
; Returns: nothing
;-----------------------------------------------------
LOCAL index:DWORD
     ; Prep esi to index each element of grid_array
     mov esi, OFFSET grid_array

     mov ecx, 0    
     .WHILE (ecx <= 60)  ; 15 * 4 = 60 (last index in grid_array)
          ; store current idx in index local
          mov index, ecx
          mov ebx, ecx

          call MapToDisplay
      
          ; Save and move to console position for current tile.
          push edx
          call Gotoxy

          ; Clear out tile on display.
          mov edx, OFFSET blank
          call WriteString
           
          ; Restore position after displaying a blank.
          pop edx

          ; Restore value of index in ecx.
          mov ecx, index
          .IF (DWORD PTR [esi + ecx] != 0)
               ; Restore position after displaying a blank.
               call Gotoxy

               ; TODO
               ; GET AND SET COLOR
               mov eax, DWORD PTR [esi + ecx]
               call SetColor

               ; Display num contained at index in grid array.
               mov eax, [esi + ecx]
               call WriteDec
          .ENDIF

          ; Move to next index in grid_array.
          add ecx, 4
     .ENDW

     ret
DisplayMove ENDP


;-----------------------------------------------------
GridMove PROC
;
; Handler for player moves. Performs a "slide" for tiles
; in a specified direction for the grid_array and console
; Receives: dir to determine direction of slide
; Returns: Updated tile_count and current_score via a "slide"
; call
;-----------------------------------------------------
    .IF dir == 'W'
        call slideUp
        jmp _endif
    .ENDIF
    .IF dir == 'A'
        call slideLeft
        jmp _endif
    .ENDIF
    .IF dir == 'S'
        call slideDown
        jmp _endif
    .ENDIF
    .IF dir == 'D'
        call slideRight
        jmp _endif
    .ENDIF

_endif:
    call DisplayMove
    ret
GridMove ENDP
end