local t1 = os.clock()
require("./tests/basic")
local d1 = os.clock() - t1
print(string.format("Basic competency tests finished in %.3fs", d1))

local t2 = os.clock()
require("./tests/bitwise/standard")
require("./tests/bitwise/rshift")
require("./tests/bitwise/arshift")
require("./tests/bitwise/rrotate")
require("./tests/bitwise/lshift")
require("./tests/bitwise/lrotate")
local d2 = os.clock() - t2
print(string.format("Bitwise tests finished in %.3fs", d2))

local t3 = os.clock()
require("./tests/arithmetic/add")
require("./tests/arithmetic/sub")
require("./tests/arithmetic/mult")
require("./tests/arithmetic/div")
require("./tests/arithmetic/pow")
local d3 = os.clock() - t3
print(string.format("Arithmetic tests finished in %.3fs", d3))
