local int64 = require("../../init")

local max = int64.from_pair(0xFFFFFFFF, 0xFFFFFFFF)
local zero = int64.from_u32(0)

local added_max = int64.add(max, max)
assert(int64.to_hex_string(added_max) == "fffffffffffffffe", "max value + max value was not correct")

local overflow = int64.add(max, int64.from_pair(0x00000400, 0x00400001))
assert(int64.to_hex_string(overflow) == "0000040000400000", "intentional overflow of components is not correct")

local zero_max = int64.add(max, zero)
assert(int64.to_hex_string(zero_max) == "ffffffffffffffff", "adding 0 changed something")

local zero_zero = int64.add(zero, zero)
assert(int64.to_hex_string(zero_zero) == "0000000000000000", "adding 0 to 0 was wrong")

local large = vector.create(2 ^ 21, 2 ^ 9, 2 ^ 21)
local added_large = int64.add(large, large)
assert(int64.to_hex_string(added_large) == "0000000100400000", "large but not overflowing addition does not work")

for lhs = 1, 2 ^ 8 do
	for rhs = 1, 2 ^ 8 do
		local real_sum = lhs + rhs
		local fake_sum = int64.add(int64.from_u32(lhs), int64.from_u32(rhs))
		if int64.to_f64(fake_sum) ~= real_sum then
			error(`{lhs} + {rhs} did not equal {real_sum} (equaled {int64.to_f64(fake_sum)})`)
		end
	end
end

return {}
