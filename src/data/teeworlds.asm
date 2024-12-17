; tw protocol

PACKET_HEADER_LEN equ 7
PACKET6_HEADER_LEN equ 3

MSG_CTRL_CONNECT equ 1
MSG_CTRL_ACCEPT equ 2
MSG_CTRL_CLOSE equ 4
MSG_CTRL_TOKEN equ 5

MSG6_CTRL_KEEPALIVE equ 0
MSG6_CTRL_CONNECT equ 1
MSG6_CTRL_CONNECTACCEPT equ 2
; MSG6_CTRL_ACCEPT equ 3 ; UNUSED!
MSG6_CTRL_CLOSE equ 4

MSG_SYSTEM_NULL equ 0
MSG_SYSTEM_INFO equ 1
MSG_SYSTEM_MAP_CHANGE equ 2
MSG_SYSTEM_MAP_DATA equ 3
MSG_SYSTEM_SERVERINFO equ 4
MSG_SYSTEM_CON_READY equ 5
MSG_SYSTEM_SNAP equ 6
MSG_SYSTEM_SNAPEMPTY equ 7
MSG_SYSTEM_SNAPSINGLE equ 8
MSG_SYSTEM_INPUTTIMING equ 10
MSG_SYSTEM_RCON_AUTH_ON equ 11
MSG_SYSTEM_RCON_AUTH_OFF equ 12
MSG_SYSTEM_RCON_LINE equ 13
MSG_SYSTEM_RCON_CMD_ADD equ 14
MSG_SYSTEM_RCON_CMD_REM equ 15
MSG_SYSTEM_READY equ 18
MSG_SYSTEM_ENTERGAME equ 19
MSG_SYSTEM_INPUT equ 20
MSG_SYSTEM_PING_REPLY equ 27
MSG_SYSTEM_MAPLIST_ENTRY_ADD equ 29
MSG_SYSTEM_MAPLIST_ENTRY_REM equ 30

MSG_GAME_NULL equ 0
MSG_GAME_SV_MOTD equ 1
MSG_GAME_SV_BROADCAST equ 2
MSG_GAME_SV_CHAT equ 3
MSG_GAME_SV_TEAM equ 4
MSG_GAME_SV_KILLMSG equ 5
MSG_GAME_SV_TUNEPARAMS equ 6
MSG_GAME_SV_READYTOENTER equ 8
MSG_GAME_SV_WEAPONPICKUP equ 9
MSG_GAME_SV_EMOTICON equ 10
MSG_GAME_SV_VOTECLEAROPTIONS equ 11
MSG_GAME_SV_VOTEOPTIONLISTADD equ 12
MSG_GAME_SV_VOTEOPTIONADD equ 13
MSG_GAME_SV_VOTEOPTIONREMOVE equ 14
MSG_GAME_SV_VOTESET equ 15
MSG_GAME_SV_VOTESTATUS equ 16
MSG_GAME_SV_SERVERSETTINGS equ 17
MSG_GAME_SV_CLIENTINFO equ 18
MSG_GAME_SV_GAMEINFO equ 19
MSG_GAME_SV_CLIENTDROP equ 20
MSG_GAME_SV_GAMEMSG equ 21
MSG_GAME_CL_STARTINFO equ 27
MSG_GAME_SV_SKINCHANGE equ 33
MSG_GAME_SV_RACEFINISH equ 35
MSG_GAME_SV_CHECKPOINT equ 36
MSG_GAME_SV_COMMANDINFO equ 37
MSG_GAME_SV_COMMANDINFOREMOVE equ 38

PAYLOAD_CTRL_TOKEN db MSG_CTRL_TOKEN, 0xDD, 0xDD, 0xCC, 0xCC, 512 dup (0x00)
PAYLOAD_CTRL_TOKEN_LEN equ $ - PAYLOAD_CTRL_TOKEN


NET_PACKETHEADERSIZE equ 7
NET_PACKETHEADERSIZE_CONNLESS equ NET_PACKETHEADERSIZE + 2
NET_MAX_PACKETHEADERSIZE equ NET_PACKETHEADERSIZE_CONNLESS

NET_MAX_PACKETSIZE equ 1400
NET_MAX_PAYLOAD equ NET_MAX_PACKETSIZE - NET_MAX_PACKETHEADERSIZE

PACKETFLAG_CONTROL     equ 0b00_0001_00
PACKETFLAG_RESEND      equ 0b00_0010_00
PACKETFLAG_COMPRESSION equ 0b00_0100_00
PACKETFLAG_CONNLESS    equ 0b00_1000_00

PACKETFLAG6_CONTROL     equ 0b0001_0000
PACKETFLAG6_CONNLESS    equ 0b0010_0000
PACKETFLAG6_RESEND      equ 0b0100_0000
PACKETFLAG6_COMPRESSION equ 0b1000_0000

CHUNKFLAG_VITAL equ 0b0100_0000
CHUNKFLAG_RESEND equ 0b1000_0000

CHUNK_SYSTEM equ 0b0000_0001
CHUNK_GAME equ 0b0000_0000

UTF8_BYTE_LENGTH equ 4

MAX_NAME_LENGTH equ 16
MAX_NAME_ARRAY_SIZE equ MAX_NAME_LENGTH * UTF8_BYTE_LENGTH + 1

MAX_CLAN_LENGTH equ 12
MAX_CLAN_ARRAY_SIZE equ MAX_CLAN_LENGTH * UTF8_BYTE_LENGTH + 1

MAX_SKIN_LENGTH equ 12
MAX_SKIN_ARRAY_SIZE equ MAX_SKIN_LENGTH * UTF8_BYTE_LENGTH + 1

MAX_CLIENTS equ 64

GAME_NETVERSION db "0.7 802f1be60a05665f", 0
CLIENT_VERSION equ 0x0705

token db 0xDD, 0xDD, 0xCC, 0xCC
peer_token db 0xFF, 0xFF, 0xFF, 0xFF

; the amount of vital chunks sent
connection_sequence db 0, 0, 0, 0

; the amount of vital chunks received
connection_ack db 0, 0, 0, 0

; the amount of vital chunks acknowledged by the peer
connection_peerack db 0, 0, 0, 0

