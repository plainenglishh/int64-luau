local int64 = require("../../init")

local test_1 = int64.mod(int64.from_pair(0, 10), int64.from_pair(0, 3))
assert(int64.to_hex_string(test_1) == "0000000000000001", "test 1 (10 % 3) failed")
assert(test_1.x == 0b0000000000000000000000, "test 1 x component was wrong")
assert(test_1.y == 0b00000000000000000000, "test 1 y component was wrong")
assert(test_1.z == 0b0000000000000000000001, "test 1 z component was wrong")

local test_2 = int64.mod(int64.from_pair(0, 25), int64.from_pair(0, 5))
assert(int64.to_hex_string(test_2) == "0000000000000000", "test 2 (25 % 5) failed")
assert(test_2.x == 0b0000000000000000000000, "test 2 x component was wrong")
assert(test_2.y == 0b00000000000000000000, "test 2 y component was wrong")
assert(test_2.z == 0b0000000000000000000000, "test 2 z component was wrong")

local test_3 = int64.mod(int64.from_pair(0, 17), int64.from_pair(0, 6))
assert(int64.to_hex_string(test_3) == "0000000000000005", "test 3 (17 % 6) failed")
assert(test_3.x == 0b0000000000000000000000, "test 3 x component was wrong")
assert(test_3.y == 0b00000000000000000000, "test 3 y component was wrong")
assert(test_3.z == 0b0000000000000000000101, "test 3 z component was wrong")

local test_4 = int64.mod(vector.zero, int64.from_pair(0, 1337))
assert(int64.to_hex_string(test_4) == "0000000000000000", "test 4 (0 % 1337) failed")
assert(test_4.x == 0b0000000000000000000000, "test 4 x component was wrong")
assert(test_4.y == 0b00000000000000000000, "test 4 y component was wrong")
assert(test_4.z == 0b0000000000000000000000, "test 4 z component was wrong")

local test_5 = int64.mod(int64.from_pair(0, 1), int64.from_pair(0, 1))
assert(int64.to_hex_string(test_5) == "0000000000000000", "test 5 (1 % 1) failed")
assert(test_5.x == 0b0000000000000000000000, "test 5 x component was wrong")
assert(test_5.y == 0b00000000000000000000, "test 5 y component was wrong")
assert(test_5.z == 0b0000000000000000000000, "test 5 z component was wrong")

local test_6 = int64.mod(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0, 1))
assert(int64.to_hex_string(test_6) == "0000000000000000", "test 6 (0xffffffffffffffff % 1) failed")
assert(test_6.x == 0b0000000000000000000000, "test 6 x component was wrong")
assert(test_6.y == 0b00000000000000000000, "test 6 y component was wrong")
assert(test_6.z == 0b0000000000000000000000, "test 6 z component was wrong")

local test_7 = int64.mod(int64.from_pair(0x0de0b6b3, 0xa763ffff), int64.from_pair(0x000462d5, 0x3c8abac0))
assert(int64.to_hex_string(test_7) == "0000000218711c7f", "test 7 (0xde0b6b3a763ffff % 0x462d53c8abac0) failed")
assert(test_7.x == 0b0000000000000000000000, "test 7 x component was wrong")
assert(test_7.y == 0b00000000100001100001, "test 7 y component was wrong")
assert(test_7.z == 0b1100010001110001111111, "test 7 z component was wrong")

local test_8 = int64.mod(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0xffffffff, 0xffffffff))
assert(int64.to_hex_string(test_8) == "0000000000000000", "test 8 (0xffffffffffffffff % 0xffffffffffffffff) failed")
assert(test_8.x == 0b0000000000000000000000, "test 8 x component was wrong")
assert(test_8.y == 0b00000000000000000000, "test 8 y component was wrong")
assert(test_8.z == 0b0000000000000000000000, "test 8 z component was wrong")

local test_9 = int64.mod(int64.from_pair(0xffffffff, 0xfffffffe), int64.from_pair(0xffffffff, 0xffffffff))
assert(int64.to_hex_string(test_9) == "fffffffffffffffe", "test 9 (0xfffffffffffffffe % 0xffffffffffffffff) failed")
assert(test_9.x == 0b1111111111111111111111, "test 9 x component was wrong")
assert(test_9.y == 0b11111111111111111111, "test 9 y component was wrong")
assert(test_9.z == 0b1111111111111111111110, "test 9 z component was wrong")

local test_10 = int64.mod(int64.from_pair(0x40000000, 0x00000000), int64.from_pair(0x00000001, 0x00000000))
assert(int64.to_hex_string(test_10) == "0000000000000000", "test 10 (0x4000000000000000 % 0x0000000100000000) failed")
assert(test_10.x == 0b0000000000000000000000, "test 10 x component was wrong")
assert(test_10.y == 0b00000000000000000000, "test 10 y component was wrong")
assert(test_10.z == 0b0000000000000000000000, "test 10 z component was wrong")

local test_11 = int64.mod(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0x00000001, 0x00000000))
assert(int64.to_hex_string(test_11) == "00000000ffffffff", "test 11 (0xffffffffffffffff % 0x0000000100000000) failed")
assert(test_11.x == 0b0000000000000000000000, "test 11 x component was wrong")
assert(test_11.y == 0b00000000001111111111, "test 11 y component was wrong")
assert(test_11.z == 0b1111111111111111111111, "test 11 z component was wrong")

local test_12 = int64.mod(int64.from_pair(0xffffffff, 0xffffffff), int64.from_pair(0, 2))
assert(int64.to_hex_string(test_12) == "0000000000000001", "test 12 (0xffffffffffffffff % 2) failed")
assert(test_12.x == 0b0000000000000000000000, "test 12 x component was wrong")
assert(test_12.y == 0b00000000000000000000, "test 12 y component was wrong")
assert(test_12.z == 0b0000000000000000000001, "test 12 z component was wrong")

local test_13 = int64.mod(int64.from_pair(0xffffffff, 0xfffffffe), int64.from_pair(0, 2))
assert(int64.to_hex_string(test_13) == "0000000000000000", "test 13 (0xfffffffffffffffe % 2) failed")
assert(test_10.x == 0b0000000000000000000000, "test 10 x component was wrong")
assert(test_10.y == 0b00000000000000000000, "test 10 y component was wrong")
assert(test_10.z == 0b0000000000000000000000, "test 10 z component was wrong")

local error_when_zero = pcall(int64.div, int64.from_pair(0, 1), vector.zero)
assert(not error_when_zero, "modulo allowed division by zero")

return {}
