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
             mov edx, [esi + eax]
             ; If base and start tiles are equal.
            .IF([esi + ebx] == edx)
                ; Combine tile to base pos tile.
                add [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0

                ; Decrement tile count and increase score
                jmp updt_scr
              back:

                ; Make the block below base the new base.
                add base, 16
            
             ; If base is empty spot.
            .ELSEIF(DWORD PTR [esi + ebx] == 0)
                ; Move tile to base pos.
                mov [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0
             
            .ELSE
                ; Move tile to pos below base.
                mov DWORD PTR [esi + eax], 0
                mov [esi + ebx + 16], edx
                ; Make the block below base the new base.
                add base, 16

            .ENDIF

        .ENDIF
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
             mov edx, [esi + eax]
             ; If base and start tiles are equal.
            .IF([esi + ebx] == edx)
                ; Combine tile to base pos tile.
                add [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0

                ; Decrement tile count and increase score
                jmp updt_scr
              back:
                ; Make the block above base the new base.
                sub base, 16
            
             ; If base is empty spot.
            .ELSEIF(DWORD PTR [esi + ebx] == 0)
                ; Move tile to base pos.
                mov [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0
             
            .ELSE
                ; Move tile to pos above base.
                mov DWORD PTR [esi + eax], 0
                mov [esi + ebx - 16], edx
              
                ; Make the block above base the new base.
                sub base, 16
            .ENDIF

        .ENDIF
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
             mov edx, [esi + eax]
             ; If base and start tiles are equal.
            .IF([esi + ebx] == edx)
                ; Combine tile to base pos tile.
                add [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0

                ; Decrement tile count and increase score
                jmp updt_scr
              back:
                ; Make the block right of base the new base.
                add base, 4
            
             ; If base is empty spot.
            .ELSEIF(DWORD PTR [esi + ebx] == 0)
                ; Move tile to base pos.
                mov [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0
             
            .ELSE
                ; Move tile to pos right base.
                mov DWORD PTR [esi + eax], 0
                mov [esi + ebx + 4], edx
              
                ; Make the block right of base the new base.
                add base, 4
            .ENDIF

        .ENDIF
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
             mov edx, [esi + eax]
             ; If base and start tiles are equal.
            .IF([esi + ebx] == edx)
                ; Combine tile to base pos tile.
                add [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0

                ; Decrement tile count and increase score
                jmp updt_scr
              back:
                ; Make the block left of base the new base.
                sub base, 4
            
             ; If base is empty spot.
            .ELSEIF(DWORD PTR [esi + ebx] == 0)
                ; Move tile to base pos.
                mov [esi + ebx], edx
                mov DWORD PTR [esi + eax], 0
             
            .ELSE
                ; Move tile to pos left of base.
                mov DWORD PTR [esi + eax], 0
                mov [esi + ebx - 4], edx
              
                ; Make the block left of base the new base.
                sub base, 4
            .ENDIF

        .ENDIF
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
slideRight ENDP

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

          ; -----------------------------------------------------
          ;call MapToDisplay
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
          ; -----------------------------------------------------
      
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