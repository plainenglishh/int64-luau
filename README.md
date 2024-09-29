# Bit64 Luau

Implementation of arithmetic and bitwise operations for 64-bit integers in pure Luau. Utilizes `vector` objects to pack the integers efficiently, meaning that each integer is both stack allocated and as small as any value in Luau can be.

Major features:
 - Arithmetic (addition, subtraction, mutiplication, and division
 - Bitwise operations (everything implemented in `bit32` as of this time)
 - Convenience functions for converting to and from other forms of data (hex strings, buffers, etc)

This does not implement `math` library functionality! Implementations of things like `math.random` are far beyond scope for this library, and implementation of things like `math.sin` are prohibitively complex and incredibly slow. It would also be very difficult to write tests for these that were appropriately exhaustive and it's irresponsible to release them into the world without tests.

If you have a bitwise operation you'd like to contribute though, or an optimization you can think of, feel free to open a pull request or issue!

## Performance

This module is as fast as is reasonably possible, however it is a LOT slower than native. Most notably, division is quite a bit slower because it is implemented as a form of long-division. Specialization is possible to improve the performance it will still be incredibly slow. Implementing it in a more efficient manner is not off the table, but it would increase complexity dramatically for unknown benefit.

Despite this note though, all of the operations are reasonably fast. Outside of division, the remaining arithmetic and bitwise operations are quite fast and completely usable.

## API

TODO: API