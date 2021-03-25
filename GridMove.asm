INCLUDE Irvine32.inc
INCLUDE GridMove.inc

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