; teeworlds_asmr by ChillerDragon
; vim: set tabstop=4:softtabstop=4:shiftwidth=4
; vim: set expandtab:
; x86_64 assembly linux ( nasm )

; 64bit register
; 00000000 00000000 00000000 0000000 00000000 00000000 00000000 00000000
;                                                               \______/
;                                                                   |
;                                                                   al
;                                                      \_______________/
;                                                               |
;                                                               ax
;                                    \_________________________________/
;                                                    |
;                                                   eax
; \____________________________________________________________________/
;                               |
;                              rax

; +-----------------------------------+
; | 8-bit  | 16-bit | 32-bit | 64-bit |
; +--------+--------+--------+--------+
; | al     | ax     | eax    | rax    |
; | bl     | bx     | ebx    | rbx    |
; | cl     | cx     | ecx    | rcx    |
; | dl     | dx     | edx    | rdx    |
; | sil    | si     | esi    | rsi    |
; | dil    | di     | edi    | rdi    |
; | bpl    | bi     | ebp    | rbp    |
; | spl    | sp     | esp    | rsp    |
; | r8b    | r8w    | r8d    | r8     |
; | r9b    | r9w    | r9d    | r9     |
; | r10b   | r10w   | r10d   | r10    |
; | r11b   | r11w   | r11d   | r11    |
; | r12b   | r12w   | r12d   | r12    |
; | r13b   | r13w   | r13d   | r13    |
; | r14b   | r14w   | r14d   | r14    |
; | r15b   | r15w   | r15d   | r15    |
; +--------+--------+--------+--------+

; System call inputs
; +-----+----------+
; | Arg | Register |
; +-----+----------+
; | ID  | rax      |
; | 1   | rdi      |
; | 2   | rsi      |
; | 3   | rdx      |
; | 4   | r10      |
; | 5   | r8       |
; | 6   | r9       |
; +-----+----------+

; rax - register a extended
; rbx - register b extended
; rcx - register c extended
; rdx - register d extended
; rbp - register base pointer (start of stack)
; rsp - register stack pointer (current location in stack, growing downwards)
; rsi - register source index (source for data copies)
; rdi - register destination index (destination for data copies)

; calling convetion for this code base is matching the one
; of linux sys calls
; so function arguments have to be filled in those registers
; in the following order:
;
; rax, rdi, rsi, rdx, r10, r8, r9
;
; and rax is used for the return value

; System call list
; /usr/include/asm/unistd_64.h
; /usr/include/x86_64-linux-gnu/asm/unistd_64.h
; https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

; db - 1 byte
; dw - 2 byte
; dd - 4 byte
; dq - 8 byte

global _start:

section .data
    ; constants
    %include "src/data/syscalls.asm"
    %include "src/data/teeworlds.asm"
    %include "src/data/terminal.asm"

    STDOUT       equ         1
    KEY_A        equ         97
    KEY_D        equ         100
    KEY_ESC      equ         27
    KEY_RETURN   equ         13
    AF_INET      equ         0x2
    SOCK_DGRAM   equ         0x2

    ; application constants
    HEX_TABLE   db "0123456789ABCDEF", 0
    newline     db 0x0a

    ; networking
    max_sockaddr_read_size dd 128
    sockaddr_localhost_8303 dw AF_INET ; 0x2 0x00
                db 0x20, 0x6f ; port 8303
                db 0x7f, 0x0, 0x0, 0x01 ; 127.0.0.1
                db 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 ; watafk is this?!

    ; strings
    s_menu      db          "+--+ teeworlds_asmr (ESCAPE to quit the game) +--+",0x0a
    l_menu      equ         $ - s_menu
    s_end       db          "quitting the game...",0x0a
    l_end       equ         $ - s_end
    s_a         db          "you pressed a",0x0a
    l_a         equ         $ - s_a
    s_d         db          "you pressed d",0x0a
    l_d         equ         $ - s_d
    s_dbg_digit db          "[debug] value of rax is: ", 0
    l_dbg_digit equ $ - s_dbg_digit
    s_got_file_desc db "got file descriptor: "
    l_got_file_desc equ $ - s_got_file_desc
    s_got_udp db "[client] got udp: "
    l_got_udp equ $ - s_got_udp
    s_len db     "[client]     len: "
    l_len equ $ - s_len
    s_blocking_read db "doing a blocking udp read ...", 0x0a
    l_blocking_read equ $ - s_blocking_read
    s_received_bytes db "[udp] received bytes: "
    l_received_bytes equ $ - s_received_bytes

section .bss
    ; 4 byte matching C int
    ; nobody ever uses a char/short to store a socket
    socket resb 4

    ; this is too long
    ; for now we only store 2 character in here
    hex_str resb 512

    ; NET_MAX_PACKETSIZE 1400
    ; tw codebase also calls recvfrom with it
    udp_recv_buf resb 1400

    ; i was too lazy to verify the size of
    ; the sockaddr struct
    ; but the tw code also uses 128 bytes :shrug:
    ;
    ; ok nvm i tested it
    ;
    ; #include <sys/socket.h>
    ; printf("%d\n", sizeof(sockaddr));
    ; => 16
    ;
    ; idk is tw using way too much space?
    ; whatever ram is free these days
    udp_srv_addr resb 128

    udp_read_len resb 4
section .text

%include "src/macros.asm"

%include "src/logger.asm"
%include "src/hex.asm"
%include "src/terminal.asm"
%include "src/udp.asm"
%include "src/printers.asm"

print_udp:
    ; got udp:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, s_got_udp
    mov rdx, l_got_udp
    syscall
    ; hexdump
    mov rax, udp_recv_buf
    mov rdi, [udp_read_len]
    call print_hexdump
    call print_newline
    ; [client]     len: %d
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, s_len
    mov rdx, l_len
    syscall
    mov rax, [udp_read_len]
    call print_uint32
    call print_newline
    ret

on_udp_packet:
    call print_udp
    ret

key_a:
    print s_a, l_a
    call send_udp
    call print_blocking_read
    call recv_udp
    mov rax, [udp_read_len]
    test rax, rax
    ; if recvfrom returned negativ
    ; we do not process the udp payload
    js keypress_end
    call on_udp_packet
    jmp keypress_end

key_d:
    print s_d, l_d
    jmp keypress_end

keypresses:
    call insane_console
    ; read char
    mov rax, SYS_READ ; __NR_read
    mov rdi, 0 ; fd: stdin
    mov rsi, terminal_input_char; buf: the temporary buffer, char
    mov rdx, 1 ; count: the length of the buffer, 1
    syscall
    call sane_console
    cmp byte[terminal_input_char], KEY_A
    jz key_a
    cmp byte[terminal_input_char], KEY_D
    jz key_d
    cmp byte[terminal_input_char], KEY_ESC
    jz end
keypress_end:
    ret

gametick:
    ; gametick
    ;
    ; main gameloop using recursion
    call keypresses
    jmp gametick

_start:
    call print_menu
    call open_socket
    call gametick

end:
    call sane_console
    ; print exit message
    mov rsi, s_end
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rdx, l_end
    syscall ; sys_write(1, s_end, l_end)
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall ; sys_exit(0)
