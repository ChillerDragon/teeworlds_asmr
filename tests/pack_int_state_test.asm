%include "tests/assert.asm"

_start:
test_packer_macro_pack_two_single_byte_ints:
    packer_reset
    pack_int 1
    pack_int 2

    mov eax, [udp_send_buf + PACKET_HEADER_LEN]
    assert_eax_eq 0x02_01 ; 0x01 0x02 is the sane people endianness

test_packer_macro_pack_two_mixed_len_byte_ints:
    packer_reset
    pack_int 65
    pack_int 2

    mov eax, [udp_send_buf + PACKET_HEADER_LEN]
    assert_eax_eq 0x02_01_81 ; 0x81 0x01 0x02 is the sane people endianness

    exit 0

