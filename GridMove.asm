INCLUDE Irvine32.inc
INCLUDE GridMove.inc

.data
blank BYTE "    ", 0

.code

slideUp PROC
LOCAL curr_col:BYTE, base:BYTE, start:BYTE, _end:BYTE, base_val:DWORD, start_val:DWORD
    ; Pointer to grid array.
    mov esi, OFFSET grid_array
    mov curr_col, 0
    mov base, 0     ; track base index (first available spot to slide to).

    mov ecx, 4      ; columns to check. 
  lp:
    ; Save begenning of base pointer.
    movzx ebx, base
    ;push ebx
    ; Starting top left, slide up for each column.
    
    
    ; Setting start index as block below base.
    movzx eax, base
    add eax, 16
    mov start, bl

    ; Column bottom index.
    mov _end, bl
    add _end, 48

    ; Loop through columns and slide tiles up for each.
    .WHILE (start <= _end)
        ; Store values at base and start.
        ;movzx edx, base
        ;mov eax, [esi + edx]
        ;mov base_val, eax
        ;movzx edx, start
        ;mov eax, [esi + edx]
        ;mov start_val, eax
        .IF([esi + start] > 0)
             mov edx, DWORD PTR [esi + start]
            .IF(DWORD PTR [esi + base] == edx)
                
            .ELSEIF([esi + base] == 0)
                mov [esi + base], edx
                mov [esi + start], 0

            .ELSE
                ;pass
            .ENDIF
        .ELSE
           ;pass
        .ENDIF
        ; Move to row below.
        add start, 16
    .ENDW

    ; Fetch base and increment to next column.
    ;pop base
    add ebx, 4
    mov base, bl
    
    loop lp


    ret




;
    ;; If tiles can combine
    ;.IF (ebx != 0 && [esi + eax + 16] == ebx && [edi + curr_idx] == 0)
        ;; Move curr pos (curr_row + curr_col) to ebx
        ;mov ebx, eax
        ;; Slide tile below (curr_row + 16) up such that curr_row tile doubles
        ;mov eax, [esi + ebx]
        ;add eax, [esi + ebx + 16]
        ;mov [esi + ebx], eax
        ;; Mark that tile as not available to combine
        ;mov [edi + curr_idx], 1
        ;; Pop the bottom tile that combined
        ;mov eax, 0
        ;mov [esi + ebx + 16], eax
        ;
        ;jmp display
;
    ;.ENDIF
  ;end_combine:  ; Goto next row (below) and repeat.
    ;inc curr_r
    ;loop lp
;
    ;ret
  ;display:
    ;; Reflect change on console
    ;; Update current position.
    ;mov dh, [dh_pos + curr_idx]
    ;mov edx, curr_col
    ;call Gotoxy
;
    ;mov edx, [esi + ebx]
    ;call WriteString
    ;; Update bottom position.
    ;mov dh, [dh_pos + curr_idx + 1]
    ;mov edx, curr_col
    ;call Gotoxy
    ;
    ;mov edx, OFFSET blank
    ;call WriteString
    ;jmp end_combine

slideUp ENDP

GridMove PROC
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
    
    invoke ExitProcess,0
GridMove ENDP
end