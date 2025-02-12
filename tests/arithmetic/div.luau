local bit64 = require("../../init")

-- For numbers that are 53 bits or less, we can cheat and use floating point
-- division. These tests are just to make sure that works, even though it's
-- more of a formality than anything.

local sno_1 = bit64.div(bit64.from_pair(0, 10), bit64.from_pair(0, 5))
assert(bit64.to_hex_string(sno_1) == "0000000000000002", "sno test 1 (10 // 5) failed")
assert(sno_1.x == 0, "sno test 1 had wrong x component")
assert(sno_1.y == 0, "sno test 1 had wrong y component")
assert(sno_1.z == 2, "sno test 1 had wrong z component")

local sno_2 = bit64.div(vector.zero, bit64.from_pair(0, 1))
assert(bit64.to_hex_string(sno_2) == "0000000000000000", "sno test 2 (0 // 1) failed")
assert(sno_2.x == 0, "sno test 2 had wrong x component")
assert(sno_2.y == 0, "sno test 2 had wrong y component")
assert(sno_2.z == 0, "sno test 2 had wrong z component")

local sno_3 = bit64.div(bit64.from_pair(0, 0x00500002), bit64.from_pair(0, 0x00400001))
assert(bit64.to_hex_string(sno_3) == "0000000000000001", "sno test 3 (0x00500002 // 0x00400001) failed")
assert(sno_3.x == 0, "sno test 3 had wrong x component")
assert(sno_3.y == 0, "sno test 3 had wrong y component")
assert(sno_3.z == 1, "sno test 3 had wrong z component")

local sno_4 = bit64.div(bit64.from_pair(0, 2), bit64.from_pair(0, 5))
assert(bit64.to_hex_string(sno_4) == "0000000000000000", "sno test 4 (10 // 5) failed")
assert(sno_4.x == 0, "sno test 4 had wrong x component")
assert(sno_4.y == 0, "sno test 4 had wrong y component")
assert(sno_4.z == 0, "sno test 4 had wrong z component")

local sno_5 = bit64.div(bit64.from_pair(0, 1336), bit64.from_pair(0, 7))
assert(bit64.to_hex_string(sno_5) == "00000000000000be", "sno test 5 (1336 / 6) failed")
assert(sno_5.x == 000, "sno test 5 had wrong x component")
assert(sno_5.y == 000, "sno test 5 had wrong y component")
assert(sno_5.z == 190, "sno test 5 had wrong z component")

-- Outside of that opimization though, the normal code paths run.

local basic_1 = bit64.div(bit64.from_pair(0xffffffff, 0xffffffff), bit64.from_pair(0, 1))
assert(bit64.to_hex_string(basic_1) == "ffffffffffffffff", "basic test 1 (0xffffffffffffffff // 0x5) failed")
assert(basic_1.x == 0x3fffff, "basic test 1 had wrong x component")
assert(basic_1.y == 0x0fffff, "basic test 1 had wrong y component")
assert(basic_1.z == 0x3fffff, "basic test 1 had wrong z component")

local basic_2 = bit64.div(bit64.from_pair(0xffffffff, 0xffffffff), bit64.from_pair(0, 5))
assert(bit64.to_hex_string(basic_2) == "3333333333333333", "basic test 2 (0xffffffffffffffff // 0x5) failed")
assert(basic_2.x == 0x0ccccc, "basic test 2 had wrong x component")
assert(basic_2.y == 0x0ccccc, "basic test 2 had wrong y component")
assert(basic_2.z == 0x333333, "basic test 2 had wrong z component")

local basic_3 = bit64.div(bit64.from_pair(0xffffffff, 0x10), bit64.from_pair(0xffffffff, 0x5))
assert(
	bit64.to_hex_string(basic_3) == "0000000000000001",
	"basic test 3 (0xffffffff00000010 // 0xffffffff00000005) failed"
)
assert(basic_3.x == 0x000000, "basic test 3 had wrong x component")
assert(basic_3.y == 0x000000, "basic test 3 had wrong y component")
assert(basic_3.z == 0x000001, "basic test 3 had wrong z component")

-- This is caught by an optimization but we assume that does not exist
-- because it's still something we should check.
local basic_4 = bit64.div(vector.zero, bit64.from_pair(0xffffffff, 0xffffffff))
assert(bit64.to_hex_string(basic_4) == "0000000000000000", "basic 4 test (0 // 0xffffffffffffffff) failed")
assert(basic_4.x == 0, "basic test 4 had wrong x component")
assert(basic_4.y == 0, "basic test 4 had wrong y component")
assert(basic_4.z == 0, "basic test 4 had wrong z component")

local basic_5 = bit64.div(bit64.from_pair(0x50000200, 0x00500002), bit64.from_pair(0x40000100, 0x00400001))
assert(
	bit64.to_hex_string(basic_5) == "0000000000000001",
	"basic test 5 (0x5000020000500002 // 0x4000010000400001) failed"
)
assert(basic_5.x == 0, "basic test 5 had wrong x component")
assert(basic_5.y == 0, "basic test 5 had wrong y component")
assert(basic_5.z == 1, "basic test 5 had wrong z component")

local basic_6 = bit64.div(bit64.from_pair(0x20000000, 0x000000), bit64.from_pair(0x50000000, 0x00000000))
assert(
	bit64.to_hex_string(basic_6) == "0000000000000000",
	"basic test 6 (0x2000000000000000 // 0x5000000000000000) failed"
)
assert(basic_6.x == 0, "basic test 6 had wrong x component")
assert(basic_6.y == 0, "basic test 6 had wrong y component")
assert(basic_6.z == 0, "basic test 6 had wrong z component")

local basic_7 = bit64.div(bit64.from_pair(0x53800000, 0x00000000), bit64.from_pair(0x00700000, 0x00000000))
assert(
	bit64.to_hex_string(basic_7) == "00000000000000be",
	"basic test 7 (0x5380000000000000 / 0x0070000000000000) failed"
)
assert(basic_7.x == 000, "basic test 5 had wrong x component")
assert(basic_7.y == 000, "basic test 5 had wrong y component")
assert(basic_7.z == 190, "basic test 5 had wrong z component")

local divide_by_zero = pcall(bit64.div, bit64.from_pair(0, 1), vector.zero)
assert(not divide_by_zero, "dividing by zero did not throw an error")

-- Just as a sanity check, we want to test around the barrier for floats.

local MAX_FLOAT = 9007199254740992 -- 2 ^ 53

local float_max = bit64.from_f64(MAX_FLOAT)
assert(bit64.to_f64(float_max) == MAX_FLOAT, "max float did not survive roundtrip")
assert(bit64.to_hex_string(float_max) == "0020000000000000", "max float had wrong hex representation")

local threshold_1 = bit64.div(float_max, float_max)
assert(
	bit64.to_hex_string(threshold_1) == "0000000000000001",
	"threshold test 1 (0x1fffffffffffff // 0x1fffffffffffff)"
)
assert(threshold_1.x == 0, "threshold test 1 had wrong x component")
assert(threshold_1.y == 0, "threshold test 1 had wrong y component")
assert(threshold_1.z == 1, "threshold test 1 had wrong z component")

-- 2 ^ 53 + 1
local float_max_plus_1 = bit64.from_pair(0x200000, 0x00000001)

local threshold_2 = bit64.div(float_max_plus_1, float_max_plus_1)
assert(
	bit64.to_hex_string(threshold_2) == "0000000000000001",
	"threshold test 2 (0x20000000000001 // 0x20000000000001)"
)
assert(threshold_2.x == 0, "threshold test 2 had wrong x component")
assert(threshold_2.y == 0, "threshold test 2 had wrong y component")
assert(threshold_2.z == 1, "threshold test 2 had wrong z component")

-- 2 ^ 53 + 2
local float_max_plus_2 = bit64.from_pair(0x200000, 0x00000002)

local threshold_3 = bit64.div(float_max_plus_2, float_max_plus_2)
assert(
	bit64.to_hex_string(threshold_3) == "0000000000000001",
	"threshold test 2 (0x20000000000002 // 0x20000000000002)"
)
assert(threshold_3.x == 0, "threshold test 3 had wrong x component")
assert(threshold_3.y == 0, "threshold test 3 had wrong y component")
assert(threshold_3.z == 1, "threshold test 3 had wrong z component")

return {}
