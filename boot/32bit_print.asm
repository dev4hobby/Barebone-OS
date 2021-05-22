[bits 32] ; 32 bit 모드

; this is how constants are defined
VIDEO_MEMORY equ 0xb8000
WHITE_OB_BLACK equ 0x0f ; 문자열을 위한 컬러바이트

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx] ; [ebx] 문자열 스택
    mov ah, WHITE_OB_BLACK

    cmp al, 0 ; 문자열 마지막인지 체크
    je print_string_pm_done

    mov [edx], ax ; 문자 저장 + 비디오 메모리 기록
    add ebx, 1 ; 다음 문자
    add edx, 2 ; 비디오메모리 다음 영역

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret