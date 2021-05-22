[bits 16]
switch_to_pm:
    cli ; 1. 인터럽트 해제
    lgdt [gdt_descriptor] ; 2. GDT 디스크립터 로드
    mov eax, cr0
    or eax, 0x1 ; 3. cr0 비트에 32-bit 모드 설정
    mov cr0, eax
    jmp CODE_SEG:init_pm ; 4. 다른 세그먼트 사용을 위해 점프


[bits 32]
init_pm: ; 이제 32비트 명령어를 사용
    mov ax, DATA_SEG ; 5. segment 레지스터를 업데이트
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; 6. 저 위에.. 공간 남는곳에 스택 하나 만들어줌
    mov esp, ebp

    call BEGIN_PM ; 7. gdt 스크립트에 만들어놓은 레이블 사용

