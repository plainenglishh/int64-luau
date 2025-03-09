local fs = require("@lune/fs")
local serde = require("@lune/serde")

local wally = serde.decode("toml", fs.readFile("wally.toml"))
local npm = serde.decode("json", fs.readFile("package.json"))

local wally_name = wally.package.name
local npm_name = string.match(npm.name, "^@(%w+/%w+)$")
assert(npm_name == wally_name, "npm name does not match wally name")

local wally_version = wally.package.version
local npm_version = npm.version
assert(npm_version == wally_version, "npm version does not match wally version")

local wally_description = wally.package.description
local npm_description = npm.description
assert(npm_description == wally_description, "npm description does not match wally description")

local wally_license = wally.package.license
local npm_license = npm.license
assert(npm_license == wally_license, "npm license does not match wally license")

local function verify_files(files: { string }, manifest_name: string)
	assert(files[1] == "init.luau", `init.luau was not first in the files list of {manifest_name}`)
	assert(files[2] == "README.md", `README.md was not second in the files list of {manifest_name}`)
	assert(files[3] == "LICENSE", `LICENSE was not third in the files list of {manifest_name}`)
	assert(files[4] == manifest_name, `{manifest_name} was not fourth in the files list of {manifest_name}`)

	local count = 0
	for _ in files do
		count += 1
	end
	assert(count == 4, `{manifest_name} had {count} files in its list instead of 4`)
end

verify_files(wally.package.include, "wally.toml")
verify_files(npm.files, "package.json")
