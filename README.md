# Int64 Luau

Implementation of arithmetic and bitwise operations for 64-bit integers in pure Luau. Utilizes `vector` objects to pack the integers efficiently, meaning it avoids expensive table accesses and allocations.

Major features:

-   Arithmetic (addition, subtraction, mutiplication, division, modulo, and exponentiation)
-   Bitwise operations (everything implemented in `bit32` as of this time except for `replace`/`extract`)
-   Convenience functions for converting to and from other forms of data (hex strings, buffers, etc)

This does not implement `math` library functionality! Implementations of things like `math.random` are far beyond scope for this library, and implementation of things like `math.sin` are prohibitively complex and incredibly slow. It would also be very difficult to write tests for these that were appropriately exhaustive and it's irresponsible to release them into the world without tests.

This module is made as fast as is reasonably possible. However, they are still a fair bit slower than native integers; this will hopefully not be a surprise. You should expect very good performance, but it's possible that depending upon your use case storing two 32-bit integers and operating on them will be faster.

If you wish to contribute to this module, whether it be through optimizations or new functionality, please open a pull request.

## API

| [Constructors](#constructors)           | [Destructors](#destructors)           | [Constants](#constants) |
| :-------------------------------------- | :------------------------------------ | :---------------------- |
| [`from_f64`](#from_f64)                 | [`to_f64`](#to_f64)                   | [`ZERO`](#ZERO)         |
| [`from_dec_string`](#from_dec_string)   | [`to_dec_string`](#to_dec_string)     | [`ONE`](#ONE)           |
| [`from_pair`](#from_pair)               | [`to_pair`](#to_pair)                 | [`TWO`](#TWO)           |
| [`from_u32`](#from_u32)                 | [`to_quartet`](#to_quartet)           | [`MAX`](#MAX)           |
| [`from_buffer`](#from_buffer)           | [`to_buffer`](#to_buffer)             | [`MAX_U32`](#MAX_U32)   |
| [`from_byte_string`](#from_byte_string) | [`write_to_buffer`](#write_to_buffer) | [`MAX_F64`](#MAX_F64)   |
|                                         | [`to_byte_string`](#to_byte_string)   | [`MAX_F32`](#MAX_F32)   |
|                                         | [`to_hex_string`](#to_hex_string)     |                         |
|                                         | [`to_bin_string`](#to_bin_string)     |                         |

| [Logical](#logical)     | [Arithmetic](#arithmetic) | [Bitwise](#bitwise)     |
| :---------------------- | :------------------------ | :---------------------- |
| [`gt`](#gt)             | [`add`](#add)             | [`band`](#band)         |
| [`gt_equal`](#gt_equal) | [`sub`](#sub)             | [`bor`](#bor)           |
| [`lt`](#lt)             | [`mult`](#mult)           | [`bxor`](#bxor)         |
| [`lt_equal`](#lt_equal) | [`div`](#div)             | [`bnot`](#bnot)         |
|                         | [`mod`](#mod)             | [`lshift`](#lshift)     |
|                         | [`pow`](#pow)             | [`rshift`](#rshift)     |
|                         |                           | [`arshift`](#arshift)   |
|                         |                           | [`lrotate`](#lrotate)   |
|                         |                           | [`rrotate`](#rrotate)   |
|                         |                           | [`countlz`](#countlz)   |
|                         |                           | [`countrz`](#countrz)   |
|                         |                           | [`btest`](#btest)       |
|                         |                           | [`byteswap`](#byteswap) |

### Constructors

#### `from_f64`

```luau
int64.from_f64(f64: number): vector
```

Constructs a 64-bit integer from the passed `f64`. Put more plainly, converts a normal Luau number to a 64-bit integer.

The number is truncated into an integer first. Note that Luau numbers cannot accurately represent integers past `2 ^ 53`.

#### `from_dec_string`

```luau
int64.from_dec_string(str: string): vector
```

Returns the provided value parsed as a 64-bit integer. Expects the provided string to contain only the digits 0-9 and will error if it does not.

Leading zeros are accepted and parsed appropriately.

Due to the implementation, the resulting integer will wrap around if it is too large to fit in a 64-bit integer rather than erroring.

#### `from_pair`

```luau
int64.from_pair(most: number, least: number): vector
```

Constructs a 64-bit integer from the passed `u32` values.

The provided `most` value fills the upper 32 bits of the integer, and the provided `least` value fills the lower 32-bits.

#### `from_u32`

```luau
int64.from_u32(u32: number): vector
```

Constructs a 64-bit integer from the passed `u32`.

This number is truncated in a 32-bit integer, even if it is larger than the max value.

#### `from_buffer`

```luau
int64.from_buffer(buf: buffer, offset: number?): vector
```

Reads a `u64` from the provided buffer. If offset is provided, reads from that spot in the buffer. Otherwise, reads from the beginning.

This function reads a little-endian value from the buffer.

#### `from_byte_string`

```luau
int64.from_byte_string(str: string, offset: number?): vector
```

Reads a `u64` from the provided string. If offset is provided, reads from that point in the string. Otherwise starts at the beginning.

This function reads a little-endian value from the string.

### Destructors

#### `to_f64`

```luau
int64.to_f64(u64: vector): number
```

Converts the provided `u64` to an `f64` (or put plainly: a normal Luau number).

This function does not check for precision loss. `f64` values lose precision past `2 ^ 53`.

#### `to_dec_string`

```luau
int64.to_dec_string(u64: vector): string
```

Returns the provided value as a string of decimal digits.

Equivalent to formatting normal numbers with `%u` or calling `tostring` on them.

#### `to_pair`

```luau
int64.to_pair(u64: vector): (number, number)
```

Converts the provided `u64` into two 32-bit integers.

This returns the most significant portion of the number first.

#### `to_quartet`

```luau
int64.to_quartet(u64: vector): (number, number, number, number)
```

Converts the provided `u64` into four 16-bit integers.

This returns the most significant portion of the number first.

#### `to_buffer`

```luau
int64.to_buffer(u64: vector): buffer
```

Converts the provided `u64` to a buffer.

The integer is written as a little-endian value.

#### `write_to_buffer`

```luau
int64.write_to_buffer(b: buffer, u64: vector, offset: number)
```

Writes the provided `u64` to the provided buffer. The value is written to the buffer at the provided offset.

The integer is written as a little-endian value.

#### `to_byte_string`

```luau
int64.to_byte_string(u64: vector): string
```

Converts the provided `u64` to string of binary data.

The integer is written as if it were little-endian.

#### `to_hex_string`

```luau
int64.to_hex_string(u64: vector): string
```

Converts the provided `u64` to a string of 16 hexadecimal digits.

The returned string will always be 16 bytes and the number is formatted as if it were big-endian. It also always uses lowercase letters.

#### `to_bin_string`

```luau
int64.to_bin_string(u64: vector): string
```

Converts the provided `u64` to a string of 64 binary digits.

The returned string will always be 64 bytes and the number is formatted as if it were big-endian.

### Constants

#### `ZERO`

A constant representing the 64-bit representation of `0`.

#### `ONE`

A constant representating the 64-bit representation of `1`.

#### `TWO`

A constant representating the 64-bit representation of `2`.

#### `MAX`

A constant representing the maximum possible 64-bit value (`18446744073709551615`, or `2 ^ 64 - 1`).

#### `MAX_U32`

A constant representing the maximum possible 32-bit value (`4294967295`, or `2 ^ 32 - 1`).

#### `MAX_F64`

A constant representing the maximum integer that is exactly representable by a normal Luau number (`9007199254740992` or `2 ^ 53`).

#### `MAX_F32`

A constant representing the maximum integer that is exactly representable by a 32-bit floating point value (`16777216`, or `2 ^ 24`).

### Logical

#### `gt`

```luau
int64.gt(lhs: vector, rhs: vector): boolean
```

Returns whether `lhs` is greater than `rhs`.

#### `gt_equal`

```luau
int64.gt_equal(lhs: vector, rhs: vector): boolean
```

Returns whether `lhs` is greater than or equal to `rhs`.

#### `lt`

```luau
int64.lt(lhs: vector, rhs: vector): boolean
```

Returns whether `lhs` is less than `rhs`.

#### `lt_equal`

```luau
int64.lt_equal(lhs: vector, rhs: vector): boolean
```

Returns whether `lhs` is less than or equal to `rhs`.

### Arithmetic

#### `add`

```luau
int64.add(augend: vector, addend: vector): vector
```

Calculates the sum of the two provided values. Equivalent to `+` for normal integers.

If the sum is equal to or greater than `2 ^ 64`, the returned value will overflow rather than expanding beyond 64 bits.

#### `sub`

```luau
int64.sub(minuend: vector, subtrahend: vector): vector
```

Calculates the difference of the two provided values. Equivalent to `-` for normal integers.

If the difference is less than `0`, the returned value will overflow rather than going negative.

#### `mult`

```luau
int64.mult(multiplier: vector, multiplicand: vector): vector
```

Calculates the product of the two provided values. Equivalent to `*` for normal integers.

If the product is greater than or equal to `2 ^ 64`, the returned value will overflow rather than expanding beyond 64 bits.

#### `div`

```luau
int64.div(dividend: vector, divisor: vector): vector
```

Calculates the quotient of the two provided values and returns it.

Equivalent to `//` for normal integers. This function will error if `divisor` is `0`.

#### `mod`

```luau
int64.mod(dividend: vector, divisor: vector): vector
```

Calculates the modulo of the two provided values. Equivalent to `%` for normal integers.
This function will error if `divisor` is `0`.

#### `pow`

```luau
int64.pow(base: vector, power: number): vector
```

Calculates the result of `base` raised to `power`. Equivalent to `^` for normal integers. `power` is interpreted as a 32-bit integer.

If the result is greater than or equal to `2 ^ 64`, the returned value will overflow rather than expanding beyond 64 bits.

Additionally, `0 ^ 0` is treated as being `1`.

### Bitwise

#### `band`

```luau
int64.band(lhs: vector, rhs: vector): vector
```

Computes the bitwise AND of the two provide values.

This does not accept a vararg like the `bit32` equivalent for performance reasons.

#### `bor`

```luau
int64.bor(lhs: vector, rhs: vector): vector
```

Computes the bitwise OR of the two provide values.

This does not accept a vararg like the `bit32` equivalent for performance reasons.

#### `bxor`

```luau
int64.bxor(lhs: vector, rhs: vector): vector
```

Computes the bitwise XOR of the two provide values.

This does not accept a vararg like the `bit32` equivalent for performance reasons.

#### `bnot`

```luau
int64.bnot(u64: vector): vector
```

Computes the bitwise negation of the provided value.

#### `lshift`

```luau
int64.lshift(u64: vector, n: number): vector
```

Shifts the provided `u64` logically left by `n` bits.

This function will error if `n` is negative.

#### `rshift`

```luau
int64.rshift(u64: vector, n: number): vector
```

Shifts the provided `u64` logically right by `n` bits.

This function will error if `n` is negative.

#### `arshift`

```luau
bit64.arshift(u64: vector, n: number): vector
```

Shifts the provided `u64` arithmetically right by `n` bits. Since these numbers are unsigned, this effectively just copies the most significant bit into the empty space rather than filling them with zeros.

This function will error if `n` is negative.

#### `lrotate`

```luau
int64.lrotate(u64: vector, n: number): vector
```

Rotates the bits of the provided `u64` left by `n` bits.

If `n` is negative, this is equivalent to `rrotate`. Otherwise, if `n` is greater than 64-bits, it will wrap around.

#### `rrotate`

```luau
int64.rrotate(u64: vector, n: number): vector
```

Rotates the bits of the provided `u64` right by `n` bits.

If `n` is negative, this is equivalent to `lrotate`. Otherwise, if `n` is greater than 64-bits, it will wrap around.

#### `countlz`

```luau
int64.countlz(u64: vector): number
```

Returns the number of consecutive zero bits in the provided `u64` starting from the left-most (most significant) bit.

#### `countrz`

```luau
int64.countrz(u64: vector): number
```

Returns the number of consecutive zero bits in the provided `u64` starting from the right-most (least significant) bit.

#### `btest`

```luau
int64.btest(lhs: vector, rhs: vector): boolean
```

Returns a boolean describing whether the bitwise AND of `lhs` and `rhs` are different than zero.

This does not accept a vararg like the `bit32` equivalent for performance reasons.

#### `byteswap`

```luau
int64.byteswap(u64: vector): vector
```

Returns the provided `u64` with the order of bytes swapped.
