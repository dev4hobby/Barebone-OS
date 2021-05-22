; 부트로더 위치
[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; 커널 link할 때 사용한거랑 같은거

    mov [BOOT_DRIVE], dl ; BIOS는 부트 드라이브를 dl로 세팅
    mov bp, 0x9000 ; 메모리영역 안겹치게 스택 위치 따로 잡아두고
    mov sp, bp

    mov bx, MSG_REAL_MODE 
    call print ; BIOS 메시지 뒤에 Print
    call print_nl

    call load_kernel ; 디스크에서 커널 불러옴
    call switch_to_pm ; 인터럽트 해제-> GDT 로드외 기타 작업마치고 'BEGIN_PM'
    jmp $ ; Hanging...

%include "boot/print.asm"
%include "boot/print_hex.asm"
%include "boot/disk.asm"
%include "boot/gdt.asm"
%include "boot/32bit_print.asm"
%include "boot/switch_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET ; 디스크에서 읽어와서 0x1000에 보관해둠
    mov dh, 31 ; 불러온 커널의 크기는 훨씬 크니까 영역을 좀 크게 잡아두기
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET
    jmp $


BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0
MSG_RETURNED_KERNEL db "Returned from kernel. Error?", 0

; padding
times 510 - ($-$$) db 0
dw 0xaa55