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
    ; Save begenning of base pointer.
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
                dec tile_count
                add edx, edx
                add current_score, edx

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
slideUp ENDP


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

          ; Save console position for current tile.
          push edx

          ; Clear out tile on display.
          mov edx, OFFSET blank
          call WriteString

          ; Restore value of index in ecx.
          mov ecx, index
          .IF (DWORD PTR [esi + ecx] != 0)
               ; Restore position after displaying a blank.
               pop edx
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
        ;call slideLeft
        jmp _endif
    .ENDIF
    .IF dir == 'S'
        ;call slideDown
        jmp _endif
    .ENDIF
    .IF dir == 'D'
        ;call slideRight
        jmp _endif
    .ENDIF

_endif:
    call DisplayMove
    ret
GridMove ENDP
end