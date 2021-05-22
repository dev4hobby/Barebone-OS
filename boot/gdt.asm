; Global descriptor table
; Real mode에서 Protected mode로 넘어오면서 추가된 테이블
; segment의 base주소와 limit등 정보가 있음
; 커널모드에서 사용하는 테이블

gdt_start: ; 이 블럭은 지우지 말아주세요.
    ; GDT는 8개의 null byte를 들고 시작
    dd 0x0 ; 4 byte
    dd 0x0 ; 4 byte

; code segment를 위한 GDT.
; base = 0x0, length = 0xfffff
; od-dev.pdf 36페이지 참조
gdt_code:
    dw 0xffff       ; segment 길이, bits 0-15
    dw 0x0          ; segment base, bits 0-15
    db 0x0          ; segment base, bits 16-23
    db 10011010b    ; flags (8 bits)
    db 11001111b    ; flags (4 bits) + segment 길이, bits 16-19
    db 0x0          ; segment 베이스, bits 24-31

; data segemt를 위한 GDT.
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit), 크키는 항상 1 작음
    dd gdt_start ; address (32 bit)

; 나중에 사용하기위해 상수 만들어둠
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
