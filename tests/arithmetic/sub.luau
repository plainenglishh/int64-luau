local bit64 = require("../../init")

local max = bit64.from_pair(0xFFFFFFFF, 0xFFFFFFFF)
local zero = bit64.from_u32(0)

local subbed_max = bit64.sub(max, max)
assert(bit64.to_hex_string(subbed_max) == "0000000000000000", "max value - max value was not correct")

local underflow = bit64.sub(bit64.from_pair(0x00000400, 0x00400001), max)
assert(bit64.to_hex_string(underflow) == "0000040000400002", "intentional underflow of components is not correct")

local zero_min = bit64.sub(zero, max)
assert(bit64.to_hex_string(zero_min) == "0000000000000001", "subtracting max from 0 was wrong")

local zero_max = bit64.sub(max, zero)
assert(bit64.to_hex_string(zero_max) == "ffffffffffffffff", "subtracting 0 changed something")

local zero_zero = bit64.sub(zero, zero)
assert(bit64.to_hex_string(zero_zero) == "0000000000000000", "subtracting 0 to 0 was wrong")

local large = vector.create(2 ^ 21 - 1, 2 ^ 20 - 1, 2 ^ 21 - 1)
local small = vector.create(10, 20, 30)
local subbed_large = bit64.sub(large, small)
assert(bit64.to_hex_string(subbed_large) == "7fffd7fffadfffe1", "large - small does not work")

for lhs = 1, 2 ^ 8 do
	for rhs = 1, 2 ^ 8 do
		-- Sadly, real subtraction supports negatives to we have to improvise.
		local real_diff = string.format("%016x", lhs - rhs)
		local fake_diff = bit64.sub(bit64.from_u32(lhs), bit64.from_u32(rhs))
		if bit64.to_hex_string(fake_diff) ~= real_diff then
			error(`{lhs} - {rhs} did not equal {real_diff} (equaled {bit64.to_hex_string(fake_diff)})`)
		end
	end
end
