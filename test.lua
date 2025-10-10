assert(love, "Must be ran in the love2d environment")
assert(love.graphics, "graphics module must be enabled")

package.path = "../?.lua;" .. package.path
local textutils = require "init" -- must be loaded from same folder.
-- local epsilon = 4.57e-15

local totalTests = 0
local passes = 0
local fails = 0
local errors = 0

local function test(name, func, expected)
	local function errorHandler(err)
		errors = errors + 1
		fails = fails + 1
		local trace = debug.traceback("", 2)
		local line = trace:match(":(%d+): in function") or "unknown"
		print(string.format("[ERROR] Test '%s' failed on line %s: %s", name, line, tostring(err)))
	end

	totalTests = totalTests + 1
	local ok, result = xpcall(func, errorHandler)

	if ok then
		if result ~= expected then
			local info = debug.getinfo(2, "Sl")
			local line = info and info.currentline or "unknown"
			print(string.format("[FAIL] Test '%s' on line %s: expected '%s', got '%s'", name, line, tostring(expected),
				tostring(result)))
			fails = fails + 1
		else
			print(string.format("[PASS] Test '%s'", name))
			passes = passes + 1
		end
	end
end

test("width1", function()
		local fontSize = 24
		local font = love.graphics.newFont(fontSize)
		local text = "HELLO WORLD"
		return textutils.getWidth(fontSize, text) == font:getWidth(text)
	end,
	true
)

test("width2", function()
		local fontSize = 24
		local font = love.graphics.newFont(fontSize)
		local text = "HELLO WORLD"
		local colored = {{1,1,1,1}, text}
		return textutils.getWidth(fontSize, colored) == font:getWidth(text)
	end,
	true
)

test("width3", function()
		local fontSize = 24
		local font = love.graphics.newFont(fontSize)
		local text = "HELLO WORLD"
		local colored = {{1,1,1,1}, "HELLO ", {1,.4,1}, "WORLD"}
		return textutils.getWidth(fontSize, colored) == font:getWidth(text)
	end,
	true
)

test("centerText1", function()
		local text = "HELLO WORLD"
		local fontSize = 24
		local font = love.graphics.newFont(fontSize)

		local start = 10
		local finish = 100

		local center = math.floor(
			start + (finish - start) / 2 - font:getWidth(text) / 2
		)

		return center == textutils.centerText(text, start, finish)
	end,
	true
)

test("centerText2", function()
		local text = "HELLO WORLD"
		local ctext = {{1,1,1,1}, "HELLO ", {1,1,1}, "WORLD"}
		local fontSize = 24
		local font = love.graphics.newFont(fontSize)

		local start = 10
		local finish = 100

		local center = math.floor(
			start + (finish - start) / 2 - font:getWidth(text) / 2
		)

		return center == textutils.centerText(ctext, start, finish)

		-- local colored = {{1,1,1,1}, "HELLO ", {1,.4,1}, "WORLD"}
		-- return textutils.getWidth(fontSize, colored) == font:getWidth(text)
	end,
	true
)

local lg = love.graphics
local fontNumber = 24
local testFont = lg.newFont(fontNumber)
lg.setFont(testFont)
local function testPrint(text, x, y, testCallback)
	lg.push("all")
	lg.setColor(1, 0, 0, 1)
	lg.print(text, x, y)
	--! there is red and I don't think it's a bug in my code, for now looking to see if it's generally the same
	--! I think it's off by less than a pixel.  It's not a big enough deal to prioritize atm.
	lg.setColor(1, 1, 1, 1) -- make sure you don't see red
	testCallback()
	lg.pop()
end

local function jPrintTest()
	textutils.jPrint("Hello JPrint1!", "left", 5, 5, fontNumber)
end

--! TEST WIP

function love.draw()
	testPrint("Hello JPrint1!", 5, 5, jPrintTest)
end
