local int64 = require("../init")

local PADDING_STRING = "\a\b\f\n\r\t\v\255\69\127"

-- Constants

assert(int64.ZERO.x == 0, "int64.ZERO x component was wrong")
assert(int64.ZERO.y == 0, "int64.ZERO y component was wrong")
assert(int64.ZERO.z == 0, "int64.ZERO z component was wrong")

assert(int64.ONE.x == 0, "int64.ONE x component was wrong")
assert(int64.ONE.y == 0, "int64.ONE y component was wrong")
assert(int64.ONE.z == 1, "int64.ONE z component was wrong")

assert(int64.TWO.x == 0, "int64.TWO x component was wrong")
assert(int64.TWO.y == 0, "int64.TWO y component was wrong")
assert(int64.TWO.z == 2, "int64.TWO z component was wrong")

assert(int64.MAX.x == 2 ^ 22 - 1, "int64.MAX x component was wrong")
assert(int64.MAX.y == 2 ^ 20 - 1, "int64.MAX y component was wrong")
assert(int64.MAX.z == 2 ^ 22 - 1, "int64.MAX z component was wrong")

assert(int64.MAX_U32.x == 0, "int64.MAX_U32 x component was wrong")
assert(int64.MAX_U32.y == 2 ^ 10 - 1, "int64.MAX_U32 y component was wrong")
assert(int64.MAX_U32.z == 2 ^ 22 - 1, "int64.MAX_U32 z component was wrong")

assert(int64.MAX_F64.x == 2 ^ 11 - 1, "int64.MAX_F64 x component was wrong")
assert(int64.MAX_F64.y == 2 ^ 20 - 1, "int64.MAX_F64 y component was wrong")
assert(int64.MAX_F64.z == 2 ^ 22 - 1, "int64.MAX_F64 z component was wrong")

assert(int64.MAX_F32.x == 0, "int64.MAX_F32 x component was wrong")
assert(int64.MAX_F32.y == 1, "int64.MAX_F32 y component was wrong")
assert(int64.MAX_F32.z == 2 ^ 22 - 1, "int64.MAX_F32 z component was wrong")

-- Constructors

local from_pair_1 = int64.from_pair(0, 0)
assert(from_pair_1.x == 0, "from_pair(0, 0) x component was wrong")
assert(from_pair_1.y == 0, "from_pair(0, 0) y component was wrong")
assert(from_pair_1.z == 0, "from_pair(0, 0) z component was wrong")

local from_pair_2 = int64.from_pair(0, 10)
assert(from_pair_2.x == 0, "from_pair(0, 10) x component was wrong")
assert(from_pair_2.y == 0, "from_pair(0, 10) y component was wrong")
assert(from_pair_2.z == 10, "from_pair(0, 10) z component was wrong")

local from_pair_3 = int64.from_pair(0xffffffff, 0xffffffff)
assert(from_pair_3.x == 2 ^ 22 - 1, "from_pair(0xffffffff, 0xffffffff) x component was wrong")
assert(from_pair_3.y == 2 ^ 20 - 1, "from_pair(0xffffffff, 0xffffffff) y component was wrong")
assert(from_pair_3.z == 2 ^ 22 - 1, "from_pair(0xffffffff, 0xffffffff) z component was wrong")

local from_pair_4 = int64.from_pair(0xdeadbeef, 0x98765432)
assert(from_pair_4.x == 0b1101111010101101101111, "from_pair(0xdeadbeef, 0x98765432) x component was wrong")
assert(from_pair_4.y == 0b10111011111001100001, "from_pair(0xdeadbeef, 0x98765432) y component was wrong")
assert(from_pair_4.z == 0b1101100101010000110010, "from_pair(0xdeadbeef, 0x98765432) z component was wrong")

local from_pair_5 = int64.from_pair(0x100000000, 0x100000000)
assert(from_pair_5.x == 0, "from_pair(0x100000000, 0x100000000) x component was wrong")
assert(from_pair_5.y == 0, "from_pair(0x100000000, 0x100000000) y component was wrong")
assert(from_pair_5.z == 0, "from_pair(0x100000000, 0x100000000) z component was wrong")

local from_u32_1 = int64.from_u32(0)
assert(from_u32_1.x == 0, "from_u32(0) x component was wrong")
assert(from_u32_1.y == 0, "from_u32(0) y component was wrong")
assert(from_u32_1.z == 0, "from_u32(0) z component was wrong")

local from_u32_2 = int64.from_u32(10)
assert(from_u32_2.x == 0, "from_u32(10) x component was wrong")
assert(from_u32_2.y == 0, "from_u32(10) y component was wrong")
assert(from_u32_2.z == 10, "from_u32(10) z component was wrong")

local from_u32_3 = int64.from_u32(0xffffffff)
assert(from_u32_3.x == 0, "from_u32(0xffffffff) x component was wrong")
assert(from_u32_3.y == 2 ^ 10 - 1, "from_u32(0xffffffff) y component was wrong")
assert(from_u32_3.z == 2 ^ 22 - 1, "from_u32(0xffffffff) z component was wrong")

local from_u32_4 = int64.from_u32(0xdeadbeef)
assert(from_u32_4.x == 0b0000000000000000000000, "from_u32(0xdeadbeef) x component was wrong")
assert(from_u32_4.y == 0b00000000001101111010, "from_u32(0xdeadbeef) y component was wrong")
assert(from_u32_4.z == 0b1011011011111011101111, "from_u32(0xdeadbeef) z component was wrong")

local from_u32_5 = int64.from_u32(0x100000000)
assert(from_u32_5.x == 0, "from_u32(0x100000000) x component was wrong")
assert(from_u32_5.y == 0, "from_u32(0x100000000) y component was wrong")
assert(from_u32_5.z == 0, "from_u32(0x100000000) z component was wrong")

local from_f64_1 = int64.from_f64(0)
assert(from_f64_1 == from_u32_1, "from_f64(0) was not correct")

local from_f64_2 = int64.from_f64(10)
assert(from_f64_2 == from_u32_2, "from_f64(10) was not correct")

local from_f64_3 = int64.from_f64(0xffffffff)
assert(from_f64_3 == from_u32_3, "from_f64(0xffffffff) was not correct")

local from_f64_4 = int64.from_f64(0xdeadbeef)
assert(from_f64_4 == from_u32_4, "from_f64(0xdeadbeef) was not correct")

local from_f64_5 = int64.from_f64(0x100000000)
assert(from_f64_5.x == 0b000000000000000000000, "from_f64(0x100000000) x component was wrong")
assert(from_f64_5.y == 0b00000000010000000000, "from_f64(0x100000000) y component was wrong")
assert(from_f64_5.z == 0b0000000000000000000000, "from_f64(0x100000000) z component was wrong")

local from_f64_6 = int64.from_f64(0x1337_deadbeef)
assert(from_f64_6.x == 0b0000000000000000000100, "from_f64(0x1337deadbeef) x component was wrong")
assert(from_f64_6.y == 0b11001101111101111010, "from_f64(0x1337deadbeef) y component was wrong")
assert(from_f64_6.z == 0b1011011011111011101111, "from_f64(0x1337deadbeef) z component was wrong")

local from_f64_7 = int64.from_f64(0x20000000000000)
assert(from_f64_7.x == 0b0000000000100000000000, "from_f64(0x20000000000000) x component was wrong")
assert(from_f64_7.y == 0b00000000000000000000, "from_f64(0x20000000000000) y component was wrong")
assert(from_f64_7.z == 0b0000000000000000000000, "from_f64(0x20000000000000) z component was wrong")

local from_f64_8 = int64.from_f64(math.pi)
assert(from_f64_8.x == 0, "from_f64(math.pi) x component was wrong")
assert(from_f64_8.y == 0, "from_f64(math.pi) y component was wrong")
assert(from_f64_8.z == 3, "from_f64(math.pi) z component was wrong")

local from_string_1_input = "\0\0\0\0\0\0\0\0"
local from_string_1 = int64.from_string(from_string_1_input)
assert(
	int64.from_string(PADDING_STRING .. from_string_1_input, 11) == from_string_1,
	"offset did not work for from_string_1"
)
assert(from_string_1.x == 0, "from_string_1 x component was wrong")
assert(from_string_1.y == 0, "from_string_1 y component was wrong")
assert(from_string_1.z == 0, "from_string_1 z component was wrong")

local from_string_2_input = "\x01\0\0\0\0\0\0\0"
local from_string_2 = int64.from_string(from_string_2_input)
assert(
	int64.from_string(PADDING_STRING .. from_string_2_input, 11) == from_string_2,
	"offset did not work for from_string_2"
)
assert(from_string_2.x == 0, "from_string_2 x component was wrong")
assert(from_string_2.y == 0, "from_string_2 y component was wrong")
assert(from_string_2.z == 1, "from_string_2 z component was wrong")

local from_string_3_input = "\x80\x80\x80\x80\x80\x80\x80\x80"
local from_string_3 = int64.from_string(from_string_3_input)
assert(
	int64.from_string(PADDING_STRING .. from_string_3_input, 11) == from_string_3,
	"offset did not work for from_string_3"
)
assert(from_string_3.x == 0b1000000010000000100000, "from_string_3 x component was wrong")
assert(from_string_3.y == 0b00100000001000000010, "from_string_3 y component was wrong")
assert(from_string_3.z == 0b0000001000000010000000, "from_string_3 z component was wrong")

local from_buffer_1 = buffer.fromstring(from_string_1_input)
local from_buffer_1_offset = buffer.fromstring(PADDING_STRING .. from_string_1_input)
assert(int64.from_buffer(from_buffer_1) == from_string_1, "from_buffer_1 was not correct")
assert(int64.from_buffer(from_buffer_1_offset, 10) == from_string_1, "offset did not work for from_buffer_1")

local from_buffer_2 = buffer.fromstring(from_string_2_input)
local from_buffer_2_offset = buffer.fromstring(PADDING_STRING .. from_string_2_input)
assert(int64.from_buffer(from_buffer_2) == from_string_2, "from_buffer_1 was not correct")
assert(int64.from_buffer(from_buffer_2_offset, 10) == from_string_2, "offset did not work for from_buffer_2")

local from_buffer_3 = buffer.fromstring(from_string_3_input)
local from_buffer_3_offset = buffer.fromstring(PADDING_STRING .. from_string_3_input)
assert(int64.from_buffer(from_buffer_3) == from_string_3, "from_buffer_3 was not correct")
assert(int64.from_buffer(from_buffer_3_offset, 10) == from_string_3, "offset did not work for from_buffer_3")

-- Deconstructors

local to_pair_1 = { int64.to_pair(from_pair_1) }
assert(to_pair_1[1] == 0, "to_pair_1 first result is wrong")
assert(to_pair_1[2] == 0, "to_pair_1 second result is wrong")

local to_pair_2 = { int64.to_pair(from_pair_2) }
assert(to_pair_2[1] == 0, "to_pair_2 first result is wrong")
assert(to_pair_2[2] == 10, "to_pair_2 second result is wrong")

local to_pair_3 = { int64.to_pair(from_pair_3) }
assert(to_pair_3[1] == 0xffffffff, "to_pair_3 first result is wrong")
assert(to_pair_3[2] == 0xffffffff, "to_pair_3 second result is wrong")

local to_pair_4 = { int64.to_pair(from_pair_4) }
assert(to_pair_4[1] == 0xdeadbeef, "to_pair_4 first result is wrong")
assert(to_pair_4[2] == 0x98765432, "to_pair_4 second result is wrong")

local to_pair_5 = { int64.to_pair(from_pair_5) }
assert(to_pair_5[1] == 0, "to_pair_5 first result is wrong")
assert(to_pair_5[1] == 0, "to_pair_5 second result is wrong")

local to_quartet_1 = { int64.to_quartet(from_pair_1) }
assert(to_quartet_1[1] == 0, "to_quartet_1 first result is wrong")
assert(to_quartet_1[2] == 0, "to_quartet_1 second result is wrong")
assert(to_quartet_1[3] == 0, "to_quartet_1 third result is wrong")
assert(to_quartet_1[4] == 0, "to_quartet_1 fourth result is wrong")

local to_quartet_2 = { int64.to_quartet(from_pair_2) }
assert(to_quartet_2[1] == 0, "to_quartet_2 first result is wrong")
assert(to_quartet_2[2] == 0, "to_quartet_2 second result is wrong")
assert(to_quartet_2[3] == 0, "to_quartet_2 third result is wrong")
assert(to_quartet_2[4] == 10, "to_quartet_2 fourth result is wrong")

local to_quartet_3 = { int64.to_quartet(from_pair_3) }
assert(to_quartet_3[1] == 0xffff, "to_quartet_3 first result is wrong")
assert(to_quartet_3[2] == 0xffff, "to_quartet_3 second result is wrong")
assert(to_quartet_3[3] == 0xffff, "to_quartet_3 third result is wrong")
assert(to_quartet_3[4] == 0xffff, "to_quartet_3 fourth result is wrong")

local to_quartet_4 = { int64.to_quartet(from_pair_4) }
assert(to_quartet_4[1] == 0xdead, "to_quartet_4 first result is wrong")
assert(to_quartet_4[2] == 0xbeef, "to_quartet_4 second result is wrong")
assert(to_quartet_4[3] == 0x9876, "to_quartet_4 third result is wrong")
assert(to_quartet_4[4] == 0x5432, "to_quartet_4 fourth result is wrong")

local to_quartet_5 = { int64.to_quartet(from_pair_5) }
assert(to_quartet_5[1] == 0, "to_quartet_5 first result is wrong")
assert(to_quartet_5[1] == 0, "to_quartet_5 second result is wrong")
assert(to_quartet_5[3] == 0, "to_quartet_5 third result is wrong")
assert(to_quartet_5[4] == 0, "to_quartet_5 fourth result is wrong")

local to_f64_1 = int64.to_f64(from_f64_1)
assert(to_f64_1 == 0, "to_f64_1 was not correct")

local to_f64_2 = int64.to_f64(from_f64_2)
assert(to_f64_2 == 10, "to_f64_2 was not correct")

local to_f64_3 = int64.to_f64(from_f64_3)
assert(to_f64_3 == 0xffffffff, "to_f64_3 was not correct")

local to_f64_4 = int64.to_f64(from_f64_4)
assert(to_f64_4 == 0xdeadbeef, "to_f64_4 was not correct")

local to_f64_5 = int64.to_f64(from_f64_5)
assert(to_f64_5 == 0x100000000, "to_f64_5 was not correct")

local to_f64_6 = int64.to_f64(from_f64_6)
assert(to_f64_6 == 0x1337_deadbeef, "to_f64_6 was not correct")

local to_f64_7 = int64.to_f64(from_f64_7)
assert(to_f64_7 == 0x20000000000000, "to_f64_7 was not correct")

local to_f64_8 = int64.to_f64(from_f64_8)
assert(to_f64_8 == 3, "to_f64_8 was not correct")

-- Stringifiers

local to_string_1 = int64.to_string(from_string_1)
assert(#to_string_1 == 8, "to_string_1 returned a string that is not 8 bytes")
assert(to_string_1 == from_string_1_input, "to_string_1 is not correct")

local to_string_2 = int64.to_string(from_string_2)
assert(#to_string_2 == 8, "to_string_2 returned a string that is not 8 bytes")
assert(to_string_2 == from_string_2_input, "to_string_2 is not correct")

local to_string_3 = int64.to_string(from_string_3)
assert(#to_string_3 == 8, "to_string_3 returned a string that is not 8 bytes")
assert(to_string_3 == from_string_3_input, "to_string_3 is not correct")

local to_buffer_1 = int64.to_buffer(from_string_1)
assert(buffer.len(to_buffer_1) == 8, "to_buffer_1 returned a buffer that is not 8 bytes")
assert(buffer.tostring(to_buffer_1) == from_string_1_input, "to_buffer_1 is not correct")

local to_buffer_2 = int64.to_buffer(from_string_2)
assert(buffer.len(to_buffer_2) == 8, "to_buffer_2 returned a buffer that is not 8 bytes")
assert(buffer.tostring(to_buffer_2) == from_string_2_input, "to_buffer_2 is not correct")

local to_buffer_3 = int64.to_buffer(from_string_3)
assert(buffer.len(to_buffer_3) == 8, "to_buffer_3 returned a buffer that is not 8 bytes")
assert(buffer.tostring(to_buffer_3) == from_string_3_input, "to_buffer_3 is not correct")

local write_buffer = buffer.create(16)

int64.write_to_buffer(write_buffer, from_string_1, 0)
int64.write_to_buffer(write_buffer, from_string_3, 8)
assert(buffer.readstring(write_buffer, 0, 8) == from_string_1_input, "write_to_buffer 1 was wrong")
assert(buffer.readstring(write_buffer, 8, 8) == from_string_3_input, "write_to_buffer 1 offset by 8 was wrong")

int64.write_to_buffer(write_buffer, from_string_2, 0)
int64.write_to_buffer(write_buffer, from_string_2, 8)
assert(buffer.readstring(write_buffer, 0, 8) == from_string_2_input, "write_to_buffer 2 was wrong")
assert(buffer.readstring(write_buffer, 8, 8) == from_string_2_input, "write_to_buffer 2 offset by 8 was wrong")

int64.write_to_buffer(write_buffer, from_string_3, 0)
int64.write_to_buffer(write_buffer, from_string_1, 8)
assert(buffer.readstring(write_buffer, 0, 8) == from_string_3_input, "write_to_buffer 3 was wrong")
assert(buffer.readstring(write_buffer, 8, 8) == from_string_1_input, "write_to_buffer 3 offset by 8 was wrong")

local to_hex_string_1 = int64.to_hex_string(from_pair_1)
assert(to_hex_string_1 == "0000000000000000", "to_hex_string_1 did not return the expected result")

local to_hex_string_2 = int64.to_hex_string(from_pair_2)
assert(to_hex_string_2 == "000000000000000a", "to_hex_string_2 did not return the expected result")

local to_hex_string_3 = int64.to_hex_string(from_pair_3)
assert(to_hex_string_3 == "ffffffffffffffff", "to_hex_string_3 did not return the expected result")

local to_hex_string_4 = int64.to_hex_string(from_pair_4)
assert(to_hex_string_4 == "deadbeef98765432", "to_hex_string_4 did not return the expected result")

local to_hex_string_5 = int64.to_hex_string(from_pair_5)
assert(to_hex_string_5 == "0000000000000000", "to_hex_string_5 did not return the expected result")

local to_bin_string_1 = int64.to_bin_string(from_pair_1)
assert(
	to_bin_string_1 == "0000000000000000000000000000000000000000000000000000000000000000",
	"to_bin_string_1 did not return the expected result"
)

local to_bin_string_2 = int64.to_bin_string(from_pair_2)
assert(
	to_bin_string_2 == "0000000000000000000000000000000000000000000000000000000000001010",
	"to_bin_string_2 did not return the expected result"
)

local to_bin_string_3 = int64.to_bin_string(from_pair_3)
assert(
	to_bin_string_3 == "1111111111111111111111111111111111111111111111111111111111111111",
	"to_bin_string_3 did not return the expected result"
)

local to_bin_string_4 = int64.to_bin_string(from_pair_4)
assert(
	to_bin_string_4 == "1101111010101101101111101110111110011000011101100101010000110010",
	"to_bin_string_4 did not return the expected result"
)

local to_bin_string_5 = int64.to_bin_string(from_pair_5)
assert(
	to_bin_string_5 == "0000000000000000000000000000000000000000000000000000000000000000",
	"to_bin_string_5 did not return the expected result"
)

-- to_binary_string relies upon a mapping of hex characters to binary digits
-- and we should ensure they're correct.
for i = 0, 255 do
	local u64 = int64.from_u32(i)
	local hex_string = int64.to_hex_string(u64)
	local bin_string = int64.to_bin_string(u64)

	assert(tonumber(hex_string, 16) == i, `hex string produced by {i} was wrong`)
	assert(tonumber(bin_string, 2) == i, `binary string produced by {i} was wrong`)
end

-- LT/LTE

local lt_1 = int64.lt(int64.from_pair(0, 0), int64.from_pair(0, 0))
assert(not lt_1, "lt_1 returned the wrong result")

local lt_2 = int64.lt(int64.from_pair(0, 0), int64.from_pair(0, 1))
assert(lt_2, "lt_2 returned the wrong result")

local lt_3 = int64.lt(int64.from_pair(0, 1), int64.from_pair(0, 0))
assert(not lt_3, "lt_3 returned the wrong result")

local lt_4 = int64.lt(int64.from_pair(0, 0), int64.from_pair(0xffffffff, 0xffffffff))
assert(lt_4, "lt_4 returned the wrong result")

local lt_5 = int64.lt(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0, 0))
assert(not lt_5, "lt_5 returned the wrong result")

local lt_6 = int64.lt(int64.from_pair(0xffffffff, 0xfffffffe), int64.from_pair(0xffffffff, 0xffffffff))
assert(lt_6, "lt_6 returned the wrong result")

local lte_1 = int64.lt_equal(int64.from_pair(0, 0), int64.from_pair(0, 0))
assert(lte_1, "lte_1 returned the wrong result")

local lte_2 = int64.lt_equal(int64.from_pair(0, 0), int64.from_pair(0, 1))
assert(lte_2, "lte_2 returned the wrong result")

local lte_3 = int64.lt_equal(int64.from_pair(0, 1), int64.from_pair(0, 0))
assert(not lte_3, "lte_3 returned the wrong result")

local lte_4 = int64.lt_equal(int64.from_pair(0, 0), int64.from_pair(0xffffffff, 0xffffffff))
assert(lte_4, "lte_4 returned the wrong result")

local lte_5 = int64.lt_equal(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0, 0))
assert(not lte_5, "lte_5 returned the wrong result")

local lte_6 = int64.lt_equal(int64.from_pair(0xffffffff, 0xfffffffe), int64.from_pair(0xffffffff, 0xffffffff))
assert(lte_6, "lte_6 returned the wrong result")

local lte_7 = int64.lt_equal(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0xffffffff, 0xffffffff))
assert(lte_7, "lte_7 returned the wrong result")

local lte_8 = int64.lt_equal(int64.from_pair(0, 0x13371337), int64.from_pair(0, 0xdeadbeef))
assert(lte_8, "lte_8 returned the wrong result")

local lte_9 = int64.lt_equal(int64.from_pair(0, 0xdeadbeef), int64.from_pair(0, 0xdeadbeef))
assert(lte_9, "lte_9 returned the wrong result")

-- GT/GTE

local gt_1 = int64.gt(int64.from_pair(0, 0), int64.from_pair(0, 0))
assert(not gt_1, "gt_1 returned the wrong result")

local gt_2 = int64.gt(int64.from_pair(0, 1), int64.from_pair(0, 0))
assert(gt_2, "gt_2 returned the wrong result")

local gt_3 = int64.gt(int64.from_pair(0, 0), int64.from_pair(0, 1))
assert(not gt_3, "gt_3 returned the wrong result")

local gt_4 = int64.gt(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0, 0))
assert(gt_4, "gt_4 returned the wrong result")

local gt_5 = int64.gt(int64.from_pair(0, 0), int64.from_pair(0xffffffff, 0xffffffff))
assert(not gt_5, "gt_5 returned the wrong result")

local gt_6 = int64.gt(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0xffffffff, 0xfffffffe))
assert(gt_6, "gt_6 returned the wrong result")

local gte_1 = int64.gt_equal(int64.from_pair(0, 0), int64.from_pair(0, 0))
assert(gte_1, "gte_1 returned the wrong result")

local gte_2 = int64.gt_equal(int64.from_pair(0, 1), int64.from_pair(0, 0))
assert(gte_2, "gte_2 returned the wrong result")

local gte_3 = int64.gt_equal(int64.from_pair(0, 0), int64.from_pair(0, 1))
assert(not gte_3, "gte_3 returned the wrong result")

local gte_4 = int64.gt_equal(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0, 0))
assert(gte_4, "gte_4 returned the wrong result")

local gte_5 = int64.gt_equal(int64.from_pair(0, 0), int64.from_pair(0xffffffff, 0xffffffff))
assert(not gte_5, "gte_5 returned the wrong result")

local gte_6 = int64.gt_equal(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0xffffffff, 0xfffffffe))
assert(gte_6, "gte_6 returned the wrong result")

local gte_7 = int64.gt_equal(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0xffffffff, 0xffffffff))
assert(gte_7, "gte_7 returned the wrong result")

local gte_8 = int64.gt_equal(int64.from_pair(0, 0xdeadbeef), int64.from_pair(0, 0x13371337))
assert(gte_8, "gte_8 returned the wrong result")

local gte_9 = int64.gt_equal(int64.from_pair(0, 0xdeadbeef), int64.from_pair(0, 0xdeadbeef))
assert(gte_9, "gte_9 returned the wrong result")

assert(int64.is_zero(int64.ZERO), "is_zero was wrong for int64.ZERO")
assert(int64.is_zero(vector.zero), "is_zero was wrong for zero vector")

assert(not int64.is_zero(int64.ONE), "is_zero was wrong for int64.ONE")
assert(not int64.is_zero(int64.TWO), "is_zero was wrong for int64.TWO")
assert(not int64.is_zero(int64.MAX), "is_zero was wrong for int64.MAX")
assert(not int64.is_zero(int64.MAX_U32), "is_zero was wrong for int64.MAX_U32")
assert(not int64.is_zero(int64.MAX_F64), "is_zero was wrong for int64.MAX_F64")
assert(not int64.is_zero(int64.MAX_F32), "is_zero was wrong for int64.MAX_F32")

assert(int64.is_zero(from_pair_1), "is_zero was wrong for from_pair_1")
assert(not int64.is_zero(from_pair_2), "is_zero was wrong for from_pair_2")
assert(not int64.is_zero(from_pair_3), "is_zero was wrong for from_pair_3")
assert(not int64.is_zero(from_pair_4), "is_zero was wrong for from_pair_4")
assert(int64.is_zero(from_pair_5), "is_zero was wrong for from_pair_5")

assert(int64.is_zero(from_u32_1), "is_zero was wrong for from_u32_1")
assert(not int64.is_zero(from_u32_2), "is_zero was wrong for from_u32_2")
assert(not int64.is_zero(from_u32_3), "is_zero was wrong for from_u32_3")
assert(not int64.is_zero(from_u32_4), "is_zero was wrong for from_u32_4")
assert(int64.is_zero(from_u32_5), "is_zero was wrong for from_u32_5")

assert(int64.is_zero(from_f64_1), "is_zero was wrong for from_f64_1")
assert(not int64.is_zero(from_f64_2), "is_zero was wrong for from_f64_2")
assert(not int64.is_zero(from_f64_3), "is_zero was wrong for from_f64_3")
assert(not int64.is_zero(from_f64_4), "is_zero was wrong for from_f64_4")
assert(not int64.is_zero(from_f64_5), "is_zero was wrong for from_f64_5")
assert(not int64.is_zero(from_f64_6), "is_zero was wrong for from_f64_6")
assert(not int64.is_zero(from_f64_7), "is_zero was wrong for from_f64_7")
assert(not int64.is_zero(from_f64_8), "is_zero was wrong for from_f64_8")

assert(int64.is_zero(from_string_1), "is_zero was wrong for from_string_1")
assert(not int64.is_zero(from_string_2), "is_zero was wrong for from_string_2")
assert(not int64.is_zero(from_string_3), "is_zero was wrong for from_string_3")

return {}
