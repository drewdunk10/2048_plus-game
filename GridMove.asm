INCLUDE Irvine32.inc
INCLUDE GridMove.inc

.data
trace_array DWORD 4 DUP(0), 0
blank BYTE "    ", 0

.code
;setupTrace PROC
    ;; Copies row or column of grid array
    ;; to trace arrray.
    ;pushad
    ;mov ecx,4     ; loop counter
    ;mov esi,0     ; start index
  ;lp:
    ;mov trace_array
    ;
;
;setupTrace ENDP

slideUp PROC
LOCAL curr_col:DWORD, curr_row:DWORD, curr_idx:DWORD, curr_r:DWORD
    mov curr_col, 0
    ; Init trace array
    ;
    ; Starting top left, slide up for each column
    mov ecx, 3      ; Rows to check 
    mov curr_r, 0   ; starting row index
  lp:
    ; Get row index (FOR GRID ARRAY)
    mov eax, curr_r
    mov bl, 16
    mul bl
    mov curr_row, eax

    ; Multiplying by 4 as it is an array of DWORDs (FOR TRACE ARRAY)
    mov eax, curr_r
    mov bl, 4
    mul bl
    mov curr_idx, eax

    mov esi, OFFSET grid_array
    mov edi, OFFSET trace_array
    mov eax, curr_row
    add eax, curr_col
    mov ebx, [esi + eax]
    ; If tiles can combine
    .IF (ebx != 0 && [esi + eax + 16] == ebx && [edi + curr_idx] == 0)
        ; Move curr pos (curr_row + curr_col) to ebx
        mov ebx, eax
        ; Slide tile below (curr_row + 16) up such that curr_row tile doubles
        mov eax, [esi + ebx]
        add eax, [esi + ebx + 16]
        mov [esi + ebx], eax
        ; Mark that tile as not available to combine
        mov [edi + curr_idx], 1
        ; Pop the bottom tile that combined
        mov eax, 0
        mov [esi + ebx + 16], eax
        
        jmp display

    .ENDIF
  end_combine:  ; Goto next row (below) and repeat.
    inc curr_r
    loop lp

    ret
  display:
    ; Reflect change on console
    ; Update current position.
    mov dh, [dh_pos + curr_idx]
    mov edx, curr_col
    call Gotoxy

    mov edx, [esi + ebx]
    call WriteString
    ; Update bottom position.
    mov dh, [dh_pos + curr_idx + 1]
    mov edx, curr_col
    call Gotoxy
    
    mov edx, OFFSET blank
    call WriteString
    jmp end_combine

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