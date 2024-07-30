; tw protocol

PACKET_HEADER_LEN equ 7

MSG_CTRL_CONNECT equ 1
MSG_CTRL_ACCEPT equ 2
MSG_CTRL_CLOSE equ 4
MSG_CTRL_TOKEN equ 5

PAYLOAD_CTRL_TOKEN db MSG_CTRL_TOKEN, 0xDD, 0xDD, 0xCC, 0xCC, 512 dup (0x00)
PAYLOAD_CTRL_TOKEN_LEN equ $ - PAYLOAD_CTRL_TOKEN
PAYLOAD_SEND_INFO db 0x40, 0x28, 0x01, 0x03, 0x30, 0x2E, 0x37, 0x20, 0x38, 0x30, 0x32, 0x66, \
                     0x31, 0x62, 0x65, 0x36, 0x30, 0x61, 0x30, 0x35, 0x36, 0x36, 0x35, 0x66, \
                     0x00, 0x6D, 0x79, 0x5F, 0x70, 0x61, 0x73, 0x73, 0x77, 0x6F, 0x72, 0x64, \
                     0x5F, 0x31, 0x32, 0x33, 0x00, 0x85, 0x1C, 0x00
PAYLOAD_SEND_INFO_LEN equ $ - PAYLOAD_SEND_INFO

NET_MAX_PACKETSIZE equ 1400

PACKETFLAG_CONTROL equ 0b00_0001_00
PACKETFLAG_RESEND equ 0b00_0010_00
PACKETFLAG_COMPRESSION equ 0b00_0100_00
PACKETFLAG_CONNLESS equ 0b00_1000_00

CHUNKFLAG_VITAL equ 0b0100_0000
CHUNKFLAG_RESEND equ 0b1000_0000

CHUNK_SYSTEM equ 0b0000_0001
CHUNK_GAME equ 0b0000_0000

token db 0xDD, 0xDD, 0xCC, 0xCC
peer_token db 0xFF, 0xFF, 0xFF, 0xFF

; the amount of vital chunks sent
connection_sequence db 0, 0, 0, 0

; the amount of vital chunks received
connection_ack db 0, 0, 0, 0

; the amount of vital chunks acknowledged by the peer
connection_peerack db 0, 0, 0, 0

