# Bit64 Luau

Implementation of arithmetic and bitwise operations for 64-bit integers in pure Luau. Utilizes `vector` objects to pack the integers efficiently, meaning it avoids expensive table accesses and allocations.

Major features:

-   Arithmetic (addition, subtraction, mutiplication, division, modulo, and exponentiation)
-   Bitwise operations (everything implemented in `bit32` as of this time)
-   Convenience functions for converting to and from other forms of data (hex strings, buffers, etc)

This does not implement `math` library functionality! Implementations of things like `math.random` are far beyond scope for this library, and implementation of things like `math.sin` are prohibitively complex and incredibly slow. It would also be very difficult to write tests for these that were appropriately exhaustive and it's irresponsible to release them into the world without tests.

This module is made as fast as is reasonably possible. However, they are still a fair bit slower than native integers; this will hopefully not be a surprise. You should expect very good performance, but it's possible that depending upon your use case storing two 32-bit integers and operating on them will be faster.

If you wish to contribute to this module, whether it be through optimizations or new functionality, please open a pull request.

## API

TODO: API
