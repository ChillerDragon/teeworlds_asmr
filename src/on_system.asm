on_system_message:
    ; on_system_message [rax] [rdi]
    ;  rax = message id
    ;  rdi = message payload
    push_registers

    ; message id
    mov r9, rax

    ; message payload
    mov r10, rdi

    print_label s_got_system_msg_with_id
    call println_uint32

    ; payload to rax
    mov rax, r10

    cmp r9d, MSG_SYSTEM_MAP_CHANGE
    je on_system_msg_map_change
    cmp r9d, MSG_SYSTEM_MAP_DATA
    je on_system_msg_map_data
    cmp r9d, MSG_SYSTEM_SERVERINFO
    je on_system_msg_serverinfo
    cmp r9d, MSG_SYSTEM_CON_READY
    je on_system_msg_con_ready
    cmp r9d, MSG_SYSTEM_SNAP
    je on_system_msg_snap
    cmp r9d, MSG_SYSTEM_SNAPEMPTY
    je on_system_msg_snapempty
    cmp r9d, MSG_SYSTEM_SNAPSINGLE
    je on_system_msg_snapsingle
    cmp r9d, MSG_SYSTEM_INPUTTIMING
    je on_system_msg_inputtiming
    cmp r9d, MSG_SYSTEM_RCON_AUTH_ON
    je on_system_msg_rcon_auth_on
    cmp r9d, MSG_SYSTEM_RCON_AUTH_OFF
    je on_system_msg_rcon_auth_off
    cmp r9d, MSG_SYSTEM_RCON_LINE
    je on_system_msg_rcon_line
    cmp r9d, MSG_SYSTEM_RCON_CMD_ADD
    je on_system_msg_rcon_cmd_add
    cmp r9d, MSG_SYSTEM_RCON_CMD_REM
    je on_system_msg_rcon_cmd_rem
    cmp r9d, MSG_SYSTEM_PING_REPLY
    je on_system_msg_ping_reply
    cmp r9d, MSG_SYSTEM_MAPLIST_ENTRY_ADD
    je on_system_msg_maplist_entry_add
    cmp r9d, MSG_SYSTEM_MAPLIST_ENTRY_REM
    je on_system_msg_maplist_entry_rem

    print_label s_unknown_system_msg
    mov rax, r9
    call println_uint32
    exit 1

on_system_message_end:
    pop_registers
    ret

on_system_msg_map_change:
    ; on_system_msg_map_change [rax]
    ;  rax = message payload
    print_label s_map_change
    call get_string
    print_c_str rax
    call print_newline

    call send_ready

    jmp on_system_message_end

on_system_msg_map_data:
    ; on_system_msg_map_data [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_serverinfo:
    ; on_system_msg_serverinfo [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_con_ready:
    ; on_system_msg_con_ready [rax]
    ;  rax = message payload

    call send_start_info

    jmp on_system_message_end

on_system_msg_snap:
    ; on_system_msg_snap [rax]
    ;  rax = message payload

    ; game tick
    call get_int
    mov dword [ack_game_tick], eax

    ; delta tick
    call get_int

    ; num parts
    call get_int

    ; part
    call get_int

    ; crc
    call get_int

    ; part size
    call get_int
    mov rdi, rax

    ; data
    call get_int

    ; there is no snapshot storage yet
    ; so we just claim there was no payload (SNAPEMPTY)
    ; when we get a partial snap

    ; data = nulltpr
    mov rax, 0
    ; data size = 0
    mov rdi, 0
    call on_snap

    jmp on_system_message_end

on_system_msg_snapempty:
    ; on_system_msg_snapempty [rax]
    ;  rax = message payload

    call get_int
    mov dword [ack_game_tick], eax

    ; data = nulltpr
    mov rax, 0
    ; data size = 0
    mov rdi, 0
    call on_snap

    jmp on_system_message_end

on_system_msg_snapsingle:
    ; on_system_msg_snapsingle [rax]
    ;  rax = message payload

    ; game tick
    call get_int
    mov dword [ack_game_tick], eax

    ; delta tick
    call get_int

    ; crc
    call get_int

    ; part size
    call get_int
    mov rdi, rax

    ; data
    call get_int

    ; rax = data
    ; rdi = part size
    call on_snap

    jmp on_system_message_end

on_system_msg_inputtiming:
    ; on_system_msg_inputtiming [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_rcon_auth_on:
    ; on_system_msg_rcon_auth_on [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_rcon_auth_off:
    ; on_system_msg_rcon_auth_off [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_rcon_line:
    ; on_system_msg_rcon_auth_off [rax]
    ;  rax = message payload

    print_label s_rcon

    call get_string
    print_c_str rax
    call print_newline

    jmp on_system_message_end

on_system_msg_rcon_cmd_add:
    ; on_system_msg_rcon_cmd_add [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_rcon_cmd_rem:
    ; on_system_msg_rcon_cmd_rem [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_ping_reply:
    ; on_system_msg_ping_reply [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_maplist_entry_add:
    ; on_system_msg_maplist_entry_add [rax]
    ;  rax = message payload
    jmp on_system_message_end

on_system_msg_maplist_entry_rem:
    ; on_system_msg_maplist_entry_add [rax]
    ;  rax = message payload
    jmp on_system_message_end

