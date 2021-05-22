; 'dx'의 데이터를 받음
; 여기서 dx주소는 0x1234라고 가정
print_hex:
    pusha
    mov cx, 0 ; 인덱스로 사용할 메모리영역

; dx의 마지막 문자를 받으면 ASCII로 변환
; '0' ~ '9' (0x30 ~ 0x39)
; 'A' ~ 'F' (0x41 ~ 0x46)
hex_loop:
    cmp cx, 4 ; 4회 반복
    je end
    
    ; 1. dx의 마지막 문자를 ASCII로 변환
    mov ax, dx ; ax를 작업용 레지스터로 사용
    and ax, 0x000f ; 0x1234 -> 0x0004
    add al, 0x30 ; base 값 더해줌
    cmp al, 0x39 ; if > 9, A~F로 표현하기 위해 8을 더해줌
    jle step2
    add al, 7 ; 'A'는 ASCII에서 65..  65-58=7

step2:
    ; ASCII 문자를 배치할 문자열의 올바른 위치를 가져옴
    ; bx == base 주소 + 문자열 길이 - index
    mov bx, HEX_OUT + 5 ; base + length
    sub bx, cx
    mov [bx], al
    ror dx, 4 ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

    ; 인덱스 값을 올리고 다시 반복
    add cx, 1
    jmp hex_loop

end:
    mov bx, HEX_OUT
    call print

    popa
    ret

HEX_OUT:
    db '0x0000',0 ; reserve memory for our new string