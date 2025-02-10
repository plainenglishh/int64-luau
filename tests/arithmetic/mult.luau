local bit64 = require("../../init")

local test_1_a = bit64.mult(bit64.from_pair(0, 3), bit64.from_pair(0, 5))
assert(bit64.to_hex_string(test_1_a) == "000000000000000f", "test 1 a (3 * 5) failed")
local test_1_b = bit64.mult(bit64.from_pair(0, 5), bit64.from_pair(0, 3))
assert(bit64.to_hex_string(test_1_b) == "000000000000000f", "test 1 b (5 * 3) failed")

local test_2_a = bit64.mult(bit64.from_pair(0, 7), bit64.from_pair(0, 11))
assert(bit64.to_hex_string(test_2_a) == "000000000000004d", "test 2 a (7 * 11) failed")
local test_2_b = bit64.mult(bit64.from_pair(0, 11), bit64.from_pair(0, 7))
assert(bit64.to_hex_string(test_2_b) == "000000000000004d", "test 2 b (11 * 7) failed")

local test_3_a = bit64.mult(vector.zero, vector.zero)
assert(test_3_a == vector.zero, "test 3 a (0 * 0) failed")
-- No associative test

local test_4_a = bit64.mult(bit64.from_pair(0, 5), vector.zero)
assert(test_4_a == vector.zero, "test 4 a (5 * 0) failed")
local test_4_b = bit64.mult(vector.zero, bit64.from_pair(0, 5))
assert(test_4_b == vector.zero, "test 4 b (0 * 5) failed")

local test_5_a = bit64.mult(bit64.from_pair(0xffffffff, 0xffffffff), vector.zero)
assert(test_5_a == vector.zero, "test 5 a (0xffffffffffffffff * 0) failed")
local test_5_b = bit64.mult(vector.zero, bit64.from_pair(0xffffffff, 0xffffffff))
assert(test_5_b == vector.zero, "test 5 a (0 * 0xffffffffffffffff) failed")

local test_6_a = bit64.mult(bit64.from_pair(0, 1), bit64.from_pair(0, 1))
assert(bit64.to_hex_string(test_6_a) == "0000000000000001", "test 6 a (1 * 1) failed")
-- No associative test

local test_7_a = bit64.mult(bit64.from_pair(0xabcdef98, 0x76543210), bit64.from_pair(0, 1))
assert(bit64.to_hex_string(test_7_a) == "abcdef9876543210", "test 7a (0xabcdef9876543210 * 1) failed")
local test_7_b = bit64.mult(bit64.from_pair(0, 1), bit64.from_pair(0xabcdef98, 0x76543210))
assert(bit64.to_hex_string(test_7_b) == "abcdef9876543210", "test 7b (1 * 0xabcdef9876543210) failed")

local test_8_a = bit64.mult(bit64.from_pair(0xffffffff, 0xffffffff), bit64.from_pair(0xffffffff, 0xffffffff))
assert(bit64.to_hex_string(test_8_a) == "0000000000000001", "test 8 a (0xffffffffffffffff * 0xffffffffffffffff) failed")
-- No associative test

--stylua: ignore
local pow_table = {
	"0000000000000002", "0000000000000004", "0000000000000008", "0000000000000010",
	"0000000000000020", "0000000000000040", "0000000000000080", "0000000000000100",
	"0000000000000200", "0000000000000400", "0000000000000800", "0000000000001000",
	"0000000000002000", "0000000000004000", "0000000000008000", "0000000000010000",
	"0000000000020000", "0000000000040000", "0000000000080000", "0000000000100000",
	"0000000000200000", "0000000000400000", "0000000000800000", "0000000001000000",
	"0000000002000000", "0000000004000000", "0000000008000000", "0000000010000000",
	"0000000020000000", "0000000040000000", "0000000080000000", "0000000100000000",
	"0000000200000000", "0000000400000000", "0000000800000000", "0000001000000000",
	"0000002000000000", "0000004000000000", "0000008000000000", "0000010000000000", 
	"0000020000000000", "0000040000000000", "0000080000000000", "0000100000000000",
	"0000200000000000", "0000400000000000", "0000800000000000", "0001000000000000",
	"0002000000000000", "0004000000000000", "0008000000000000", "0010000000000000",
	"0020000000000000", "0040000000000000", "0080000000000000", "0100000000000000",
	"0200000000000000", "0400000000000000", "0800000000000000", "1000000000000000",
	"2000000000000000", "4000000000000000", "8000000000000000",
}

assert(#pow_table == 63, "pow table was wrong length")

local last = bit64.from_pair(0, 1)

for i, expected in pow_table do
	last = bit64.mult(last, bit64.from_pair(0, 2))
	if bit64.to_hex_string(last) ~= expected then
		local truncated = string.match(expected, "^0*(%x+)$") or expected
		error(`mult by 2 cycle {i} failed (0x{truncated} * 2 was wrong)`)
	end
end
