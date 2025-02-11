--!native
--!optimize 2

-- stylua: ignore
local HEX_TO_BINARY = {
    ["0"] = "0000", ["1"] = "0001", ["2"] = "0010", ["3"] = "0011",
    ["4"] = "0100", ["5"] = "0101", ["6"] = "0110", ["7"] = "0111",
    ["8"] = "1000", ["9"] = "1001", ["a"] = "1010", ["b"] = "1011",
    ["c"] = "1100", ["d"] = "1101", ["e"] = "1110", ["f"] = "1111",
}

local ZERO = vector.create(0, 0, 0)
local ONE = vector.create(0, 0, 1)
local TWO = vector.create(0, 0, 2)

local MAX = vector.create(0x3fffff, 0xfffff, 0x3fffff)
local MAX_U32 = vector.create(0, 0x3ff, 0x3fffff)
local MAX_F64 = vector.create(0x7ff, 0xfffff, 0x3fffff)
local MAX_F32 = vector.create(0, 1, 0x3fffff)

local function u64_from_pair(most: number, least: number): vector
	-- 32 - 22 = 10
	-- x = upper 22 of most
	-- y = lower 10 of most and upper 10 of least
	-- z = lower 22 of least
	return vector.create(
		bit32.rshift(most, 10),
		bit32.bor(bit32.extract(least, 22, 10), bit32.lshift(bit32.band(most, 0b1111_1111_11), 10)),
		bit32.band(least, 0b1111_1111_1111_1111_1111_11)
	)
end

local function u64_from_u32(u32: number): vector
	return u64_from_pair(0, u32) -- TODO: efficiency
end

local function u64_from_f64(f64: number): vector
	return u64_from_pair(bit32.bor(f64 // 2 ^ 32), bit32.bor(f64 % 2 ^ 32))
end

--[=[
	Reads a `u64` from the provided buffer. If offset is provided, reads from
	that spot in the buffer. Otherwise, reads from the beginning.

	This function reads a little-endian value from the buffer.
]=]
local function u64_from_buffer(buf: buffer, offset: number?): vector
	offset = offset or 0
	local least = buffer.readu32(buf, offset :: number)
	local most = buffer.readu32(buf, offset :: number + 4)

	return u64_from_pair(most, least)
end

--[=[
	Reads a `u64` from the provided string. If offset is provided, reads from
	that point in the string. Otherwise starts at the beginning.

	This function reads a little-endian value from the string.
]=]
local function u64_from_string(str: string, offset: number?): vector
	offset = offset or 1
	-- This is deliberately backwards because we expect a little endian input
	local d, c, b, a, h, g, f, e = string.byte(str, offset, offset :: number + 7)
	local least = bit32.bor(bit32.lshift(bit32.replace(b, a, 8, 8), 16), bit32.replace(d, c, 8, 8))
	local most = bit32.bor(bit32.lshift(bit32.replace(f, e, 8, 8), 16), bit32.replace(h, g, 8, 8))

	return u64_from_pair(most, least)
end

local function u32_from_u64(u64: vector): (number, number)
	-- x = upper 22 of most
	-- y = lower 10 of most and upper 10 of least
	-- z = lower 22 of least
	local most = bit32.bor(bit32.lshift(u64.x, 10), bit32.rshift(u64.y, 10))
	local least = bit32.bor(bit32.lshift(u64.y, 22), u64.z)

	return most, least
end

local function u16_from_u64(u64: vector): (number, number, number, number)
	-- 0000000000000000000000 00000000000000000000 0000000000000000000000
	-- 0000000000000000 000000 0000000000 0000000000 000000 0000000000000000
	-- 1111000111100010 1101001111000100 1000000010011010 1011110011011110
	local most, least = u32_from_u64(u64)
	local q1, q2 = bit32.rshift(most, 16), bit32.band(most, 0xffff)
	local q3, q4 = bit32.rshift(least, 16), bit32.band(least, 0xffff)
	-- local q1 = bit32.rshift(u64.x, 6)
	-- local q2 = bit32.bor(bit32.lshift(u64.y, 16), bit32.rshift(u64.y, 10))
	-- local q3 = bit32.bor(bit32.band(u64.y, 0b1111_1111_11), bit32.rshift(u64.z, 16))
	-- local q4 = bit32.band(0b1111_1111_1111_1111)
	return q1, q2, q3, q4
end

local function to_f64(u64: vector): number
	local most, least = u32_from_u64(u64)
	return most * 2 ^ 32 + least
end

local function to_bytes_buffer(u64: vector): buffer
	local most, least = u32_from_u64(u64)
	local buf = buffer.create(8)
	-- We use a little endian format because it doesn't matter and most
	-- systems we run on are little endian so it'll be nicer for them.
	buffer.writeu32(buf, 0, least)
	buffer.writeu32(buf, 4, most)
	return buf
end

local function to_bytes_string(u64: vector): string
	local most, least = u32_from_u64(u64)
	-- Previous implementation of this used `%c` but it turns out that
	-- `string.format("%c", 0)` results in a zero length string!
	return string.char(
		bit32.band(least, 0xFF),
		bit32.extract(least, 8, 8),
		bit32.extract(least, 16, 8),
		bit32.rshift(least, 24),
		bit32.band(most, 0xFF),
		bit32.extract(most, 8, 8),
		bit32.extract(most, 16, 8),
		bit32.rshift(most, 24)
	)
end

--[=[
	Converts the provided `u64` to a string of 16 hexadecimal digits.
	The returned string will always be 16 bytes and the number is formatted as
	if it were big-endian.
]=]
local function to_hex_string(u64: vector): string
	local most, least = u32_from_u64(u64)
	return string.format("%08x%08x", most, least)
end

--[=[
	Converts the provided `u64` to a string of 64 binary digits.
	The returned string will always be 64 bytes and the number is formatted as
	if it were big-endian.
]=]
local function to_bin_string(u64: vector): string
	-- horrible, inefficent, terrible.
	return (string.gsub(to_hex_string(u64), "(.)", HEX_TO_BINARY))
end

--[=[
	Returns whether the provided `u64` is zero or not.

	Equivalent to `u64 == from_u32(0)`.
]=]
local function is_zero(u64: vector): boolean
	return u64 == ZERO
end

--[=[
	Normalizes the u64. Neecessary to ensure the internal logic is
	consistent.
]=]
local function normalize(u64: vector): vector
	return vector.create(
		bit32.band(u64.x, 0b1111_1111_1111_1111_1111_11),
		bit32.band(u64.y, 0b1111_1111_1111_1111_1111),
		bit32.band(u64.z, 0b1111_1111_1111_1111_1111_11)
	)
end

--[=[
	Computes the bitwise AND of the two provide values.

	This does not accept a vararg like the `bit32` equivalent for performance
	reasons.
]=]
local function band(lhs: vector, rhs: vector): vector
	return vector.create(bit32.band(lhs.x, rhs.x), bit32.band(lhs.y, rhs.y), bit32.band(lhs.z, rhs.z))
end

--[=[
	Computes the bitwise OR of the two provide values.

	This does not accept a vararg like the `bit32` equivalent for performance
	reasons.
]=]
local function bor(lhs: vector, rhs: vector): vector
	return vector.create(bit32.bor(lhs.x, rhs.x), bit32.bor(lhs.y, rhs.y), bit32.bor(lhs.z, rhs.z))
end

--[=[
	Computes the bitwise XOR of the two provide values.

	This does not accept a vararg like the `bit32` equivalent for performance
	reasons.
]=]
local function bxor(lhs: vector, rhs: vector): vector
	return vector.create(bit32.bxor(lhs.x, rhs.x), bit32.bxor(lhs.y, rhs.y), bit32.bxor(lhs.z, rhs.z))
end

--[=[
	Computes the bitwise negation of the provided value.
]=]
local function bnot(u64: vector): vector
	return vector.create(bit32.bnot(u64.x), bit32.bnot(u64.y), bit32.bnot(u64.z))
end

--[=[
	Shifts the provided `u64` logically left by `n` bits.

	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function lshift(u64: vector, n: number): vector
	if n == 0 then
		return u64
	end
	local most, least = u32_from_u64(u64)
	if n < 32 then
		local remainder = 32 - n
		local ret =
			u64_from_pair(bit32.replace(bit32.rshift(least, remainder), most, n, remainder), bit32.lshift(least, n))
		return ret
	else
		local ret = u64_from_pair(bit32.lshift(least, n - 32), 0)
		return ret
	end
end

--[=[
	Shifts the provided `u64` logically right by `n` bits.

	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function rshift(u64: vector, n: number): vector
	if n == 0 then
		return u64
	end
	local most, least = u32_from_u64(u64)
	if n < 32 then
		local ret = u64_from_pair(bit32.rshift(most, n), bit32.replace(bit32.rshift(least, n), most, 32 - n, n))
		return ret
	else
		local ret = u64_from_pair(0, bit32.rshift(most, n - 32))
		return ret
	end
end

--[=[
	Shifts the provided `u64` arithmetically right by `n` bits. Since these
	numbers are unsigned, this effectively just copies the most significant
	bit into the empty space rather than filling them with zeros.

	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function arshift(u64: vector, n: number): vector
	if n == 0 then
		return u64
	end
	local most, least = u32_from_u64(u64)
	if n < 32 then
		local ret = u64_from_pair(bit32.arshift(most, n), bit32.replace(bit32.rshift(least, n), most, 32 - n, n))
		return ret
	else
		local ret = u64_from_pair(
			if bit32.btest(most, 0x8000_0000) then 0xFFFF_FFFF else 0x0000_0000,
			bit32.arshift(most, n - 32)
		)
		return ret
	end
end

--[=[
	Rotates the bits of the provided `u64` left by `n` bits. 

	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function lrotate(u64: vector, n: number): vector
	if n == 64 then
		return u64
	else
		local lshifted = lshift(u64, n)
		local rshifted = rshift(u64, 64 - n)
		return bor(lshifted, rshifted)
	end
end

--[=[
	Rotates the bits of the provided `u64` right by `n` bits. 

	This function will error if `n` is outside the range `[0, 64]`.
]=]
local function rrotate(u64: vector, n: number): vector
	if n == 64 then
		return u64
	else
		local lshifted = rshift(u64, n)
		local rshifted = lshift(u64, 64 - n)
		return bor(lshifted, rshifted)
	end
end

--[=[
	Returns the number of consecutive zero bits in the provided `u64` starting
	from the left-most (most significant) bit.
]=]
local function countlz(u64: vector): number
	local most, least = u32_from_u64(u64)
	if most == 0 then
		return bit32.countlz(least) + 32
	else
		return bit32.countlz(most)
	end
end

--[=[
	Returns the number of consecutive zero bits in the provided `u64` starting
	from the right-most (least significant) bit.
]=]
local function countrz(u64: vector): number
	local most, least = u32_from_u64(u64)
	if least == 0 then
		return bit32.countrz(most) + 32
	else
		return bit32.countrz(least)
	end
end

--[=[
	Returns a boolean describing whether the bitwise AND of `lhs` and
	`rhs` are different than zero.

	This does not accept a vararg like the `bit32` equivalent for performance
	reasons.
]=]
local function btest(lhs: vector, rhs: vector): boolean
	return is_zero(band(lhs, rhs))
end

--[=[
	Returns the provided `u64` with the order of bytes swapped.
]=]
local function byteswap(u64: vector): vector
	local most, least = u32_from_u64(u64)
	return u64_from_pair(bit32.byteswap(least), bit32.byteswap(most))
end

--[=[
	Returns whether `lhs` is greater than `rhs`.
]=]
local function gt(lhs: vector, rhs: vector): boolean
	local l_most, l_least = u32_from_u64(lhs)
	local r_most, r_least = u32_from_u64(rhs)

	if l_most == r_most then
		return l_least > r_least
	else
		return l_most > r_most
	end
end

--[=[
	Returns whether `lhs` is greater than or equal to `rhs`.
]=]
local function gt_equal(lhs: vector, rhs: vector): boolean
	return lhs == rhs or gt(lhs, rhs)
end

--[=[
	Returns whether `lhs` is less than `rhs`.
]=]
local function lt(lhs: vector, rhs: vector): boolean
	local l_most, l_least = u32_from_u64(lhs)
	local r_most, r_least = u32_from_u64(rhs)

	if l_most == r_most then
		return l_least < r_least
	else
		return l_most < r_most
	end
end

--[=[
	Returns whether `lhs` is less than or equal to `rhs`.
]=]
local function lt_equal(lhs: vector, rhs: vector): boolean
	return lhs == rhs or lt(lhs, rhs)
end

--[=[
	Calculates the sum of the two provided values. Equivalent to `+` for
	normal integers.
	
	If the sum is equal to or greater than 2^64, the returned value will
	overflow rather than expanding beyond 64 bits.
]=]
local function add(lhs: vector, rhs: vector): vector
	local prime = lhs + rhs

	prime += vector.create(if prime.y > (2 ^ 20 - 1) then 1 else 0, if prime.z > (2 ^ 22 - 1) then 1 else 0, 0)

	return prime
end

--[=[
	Calculates the difference of the two provided values. Equivalent to `-` for
	normal integers.
	
	If the difference is less than 0, the returned value will overflow rather
	than going negative.
]=]
local function sub(lhs: vector, rhs: vector): vector
	local prime = lhs - rhs

	local adjust_z = prime.z
	local adjust_y = prime.y
	local adjust_x = prime.x

	local borrow_z = prime.z < 0
	if borrow_z then
		adjust_z += 2 ^ 22
	end

	if borrow_z then
		adjust_y -= 1
	end
	local borrow_y = adjust_y < 0
	if borrow_y then
		adjust_y += 2 ^ 20
	end

	if borrow_y then
		adjust_x -= 1
	end
	local borrow_x = adjust_x < 0
	if borrow_x then
		adjust_x += 2 ^ 22
	end

	return vector.create(adjust_x, adjust_y, adjust_z)
end

--[=[
	Calculates the product of the two provided values. Equivalent to `*` for
	normal integers.
	
	If the product is greater than or equal to 2^64, the returned value will
	overflow rather than expanding beyond 64-bits.
]=]
local function mult(lhs: vector, rhs: vector): vector
	-- We represent 64-bit numbers as two 32-bit ones.
	-- Multiplying them is:
	-- (A + B) * (C + D) = (A * C) + (A * D) + (B * C) + (B * D)
	--
	-- However, multiplying two 32-bit numbers might overflow. So, we need to
	-- use 16-bit numbers. This turns out math into this:
	-- (A + B + C + D) * (E + F + G + H) =
	-- 		(A * E) + (A * F) + (A * G) + (A * H) +
	-- 		(B * E) + (B * F) + (B * G) + (B * H) +
	-- 		(C * E) + (C * F) + (C * G) + (C * H) +
	-- 		(D * E) + (D * F) + (D * G) + (D * H)
	--
	-- We can skip (A * E), (A * F), (A * G), (B * E), (B * F), and (C * F)
	-- because they don't exist within the bounds of the final product.
	-- Since the numbers are built as A * 2 ^ 48 + B * 2 ^ 32 + C * 2 ^ 16 + D
	-- you end up with e.g. (A * 2 ^ 48 * E * 2 ^ 48) which is A * E * 2^96.
	-- Otherwise... Here we go.

	local a, b, c, d = u16_from_u64(lhs)
	local e, f, g, h = u16_from_u64(rhs)

	local product_4 = d * h
	local product_3 = bit32.rshift(product_4, 16) + c * h
	local product_2 = bit32.rshift(product_3, 16)
	product_3 = bit32.band(product_3, 0xFFFF) + d * g

	product_2 += bit32.rshift(product_3, 16) + b * h
	local product_1 = bit32.rshift(product_2, 16)

	product_2 = bit32.band(product_2, 0xFFFF) + c * g
	product_1 += bit32.rshift(product_2, 16)
	product_2 = bit32.band(product_2, 0xFFFF) + d * f
	product_1 += bit32.rshift(product_2, 16) + a * h + b * g + c * f + d * e

	-- We skip truncating any of the products the last time since they'll never
	-- overflow and bit32 will truncate them for us.

	return u64_from_pair(bit32.replace(product_2, product_1, 16, 16), bit32.replace(product_4, product_3, 16, 16))
end

--[=[
	Calculates the product of the two provided values. Equivalent to `//` for
	normal integers. 
	
	This function will error if `rhs` is 0.
]=]
local function div(lhs: vector, rhs: vector): vector
	if is_zero(rhs) then
		error("cannot divide integers by zero")
	elseif countlz(lhs) >= 11 and countlz(rhs) >= 11 then
		local l_real = to_f64(lhs)
		local r_real = to_f64(rhs)
		return u64_from_f64(l_real / r_real) -- , u64_from_f64(math.fmod(l_real, r_real))
	end

	local quotient = ZERO
	local remainder = lhs

	-- Doing extra iterations of this is very bad!
	for i = math.abs(countlz(lhs) - countlz(rhs)), 0, -1 do
		local shifted_divisor = lshift(rhs, i)

		if gt_equal(remainder, shifted_divisor) then
			remainder = sub(remainder, shifted_divisor)
			quotient = bor(quotient, lshift(ONE, i))
		end
	end

	return quotient
end

--[=[
	Calculates the modulo of the two provided values. Equivalent to `%` for
	normal integers.
	
	This function will error if `rhs` is 0.
]=]
local function mod(lhs: vector, rhs: vector): vector
	if rhs == ZERO then
		error("cannot divide integers by 0")
	end

	return sub(lhs, mult(div(lhs, rhs), rhs))
end

--[=[
	Calculates the result of `base` raised to `power`. Equivalent to `%` for
	normal integers. `power` is interpreted as a 32-bit integer.

	If the result is greater than or equal to 2^64, the returned value will
	overflow rather than expanding beyond 64-bits.
	
	Additionally, `0 ^ 0` is treated as being `1`.
]=]
local function pow(base: vector, power: number): vector
	if power == 0 then
		return ONE
	elseif band(base, sub(base, ONE)) == ZERO then
		return lshift(ONE, countrz(base) * power)
	end

	local power_vec = u64_from_u32(power)
	local result = ONE
	for i = 64, 1, -1 do
		if not btest(power_vec, ONE) then
			result = mult(result, base)
		end
		base = mult(base, base)
		power_vec = rshift(power_vec, 1)
	end
	return result
end

-- TODO: then bitwise ops

local n = u64_from_pair(0, 4)
local n_2 = 4
local d = pow(n, n_2)
-- local d_2 = mult_2(n, n_2)
print(d.x, d.y, d.z)
-- print(d_2.x, d_2.y, d_2.z)
print(to_hex_string(d))
-- print(to_hex_string(d_2))

-- local t1 = os.clock()
-- local c1 = 0
-- while os.clock() - t1 <= 1 do
-- 	c1 += 1
-- 	pow(n, n_2)
-- end
-- print("Cycles before:", c1)
-- local t2 = os.clock()
-- local c2 = 0
-- while os.clock() - t2 <= 1 do
-- 	c2 += 1
-- 	mult_2(n, n_2)
-- end
-- print("Cycles after: ", c2)

-- TODO: replace and extract
-- TODO: to_decimal_string
-- TODO: vararg versions of band, bor, bxor
-- TODO: normalize

return {
	--- The number `0`.
	ZERO = ZERO,
	--- The number `1`.
	ONE = ONE,
	--- The number `2`.
	TWO = TWO,
	--- The maximum value of a `u64` (2 ^ 64 - 1).
	MAX = MAX,
	--- The maximum value of a `u32` (2 ^ 32 - 1).
	MAX_U32 = MAX_U32,
	--- The maximum supported integer value for an `f64` (2 ^ 53 - 1).
	MAX_F64 = MAX_F64,
	--- The maximum supported integer value for an `f32` (2 ^ 23 - 1).
	MAX_F32 = MAX_F32,

	from_pair = u64_from_pair,
	from_u32 = u64_from_u32,
	from_f64 = u64_from_f64,
	from_string = u64_from_string,
	from_buffer = u64_from_buffer,

	to_pair = u32_from_u64,
	to_quartet = u16_from_u64,
	to_f64 = to_f64,

	to_string = to_bytes_string,
	to_buffer = to_bytes_buffer,
	to_hex_string = to_hex_string,
	to_bin_string = to_bin_string,

	lt = lt,
	lt_equal = lt_equal,
	gt = gt,
	gt_equal = gt_equal,

	band = band,
	bor = bor,
	bxor = bxor,
	btest = btest,

	bnot = bnot,
	byteswap = byteswap,
	countlz = countlz,
	countrz = countrz,

	rshift = rshift,
	arshift = arshift,
	rrotate = rrotate,
	lshift = lshift,
	lrotate = lrotate,

	add = add,
	sub = sub,
	mult = mult,
	div = div,
	mod = mod,
	pow = pow,
}
