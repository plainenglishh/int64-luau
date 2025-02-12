local bit64 = require("../../init")

local test_1 = bit64.mod(bit64.from_pair(0, 10), bit64.from_pair(0, 3))
assert(bit64.to_hex_string(test_1) == "0000000000000001", "test 1 (10 % 3) failed")

local test_2 = bit64.mod(bit64.from_pair(0, 25), bit64.from_pair(0, 5))
assert(bit64.to_hex_string(test_2) == "0000000000000000", "test 2 (25 % 5) failed")

local test_3 = bit64.mod(bit64.from_pair(0, 17), bit64.from_pair(0, 6))
assert(bit64.to_hex_string(test_3) == "0000000000000005", "test 3 (17 % 6) failed")

local test_4 = bit64.mod(vector.zero, bit64.from_pair(0, 1337))
assert(bit64.to_hex_string(test_4) == "0000000000000000", "test 4 (0 % 1337) failed")

local test_5 = bit64.mod(bit64.from_pair(0, 1), bit64.from_pair(0, 1))
assert(bit64.to_hex_string(test_5) == "0000000000000000", "test 5 (1 % 1) failed")

local test_6 = bit64.mod(bit64.from_pair(0xffffffff, 0xffffffff), bit64.from_pair(0, 1))
assert(bit64.to_hex_string(test_6) == "0000000000000000", "test 6 (0xffffffffffffffff % 1) failed")

local test_7 = bit64.mod(bit64.from_pair(0x0de0b6b3, 0xa763ffff), bit64.from_pair(0x000462d5, 0x3c8abac0))
assert(bit64.to_hex_string(test_7) == "0000000218711c7f", "test 7 (0xde0b6b3a763ffff % 0x462d53c8abac0) failed")

local test_8 = bit64.mod(bit64.from_pair(0xffffffff, 0xffffffff), bit64.from_pair(0xffffffff, 0xffffffff))
assert(bit64.to_hex_string(test_8) == "0000000000000000", "test 8 (0xffffffffffffffff % 0xffffffffffffffff) failed")

local test_9 = bit64.mod(bit64.from_pair(0xffffffff, 0xfffffffe), bit64.from_pair(0xffffffff, 0xffffffff))
assert(bit64.to_hex_string(test_9) == "fffffffffffffffe", "test 9 (0xfffffffffffffffe % 0xffffffffffffffff) failed")

local test_10 = bit64.mod(bit64.from_pair(0x40000000, 0x00000000), bit64.from_pair(0x00000001, 0x00000000))
assert(bit64.to_hex_string(test_10) == "0000000000000000", "test 10 (0x4000000000000000 % 0x0000000100000000) failed")

local test_11 = bit64.mod(bit64.from_pair(0xffffffff, 0xffffffff), bit64.from_pair(0x00000001, 0x00000000))
assert(bit64.to_hex_string(test_11) == "00000000ffffffff", "test 11 (0xffffffffffffffff % 0x0000000100000000) failed")

local test_12 = bit64.mod(bit64.from_pair(0xffffffff, 0xffffffff), bit64.from_pair(0, 2))
assert(bit64.to_hex_string(test_12) == "0000000000000001", "test 12 (0xffffffffffffffff % 2) failed")

local test_13 = bit64.mod(bit64.from_pair(0xffffffff, 0xfffffffe), bit64.from_pair(0, 2))
assert(bit64.to_hex_string(test_13) == "0000000000000000", "test 13 (0xfffffffffffffffe % 2) failed")

local error_when_zero = pcall(bit64.div, bit64.from_pair(0, 1), vector.zero)
assert(not error_when_zero, "modulo allowed division by zero")

return {}
