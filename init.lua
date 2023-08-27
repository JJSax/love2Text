
assert(love, "textutils can only be ran on the love2d framework.")
assert(love.graphics, "love.graphics not found.  Please enable it in conf.lua.")

local utils = {
	fonts = {},
	_VERSION = "0.1.0"
}
local fonts = utils.fonts

function utils.setFont(size)
	if not fonts[size] then fonts[size] = love.graphics.newFont(size) end
	love.graphics.setFont(fonts[size])
	return fonts[size]
end

function utils.lgprint(text, x, y, r, sx, sy, ox, oy, kx, ky)
	-- floor coordinates to avoid text blurring
	--! test for scaling.  Maybe better to make a new font with scale.
	--!  Avoid blurring

	x = math.floor(x or 0)
	y = math.floor(y or 0)
	love.graphics.print( text, x, y, r, sx, sy, ox, oy, kx, ky )

end
utils.print = utils.lgprint
-- printf

local jMap = {
	-- y is the top of the text
	-- Let x define where the right of the text will be
	right = function(t, f) return f:getWidth(t), 0 end,
	-- Let x define where the left of the text will be
	left = function() return 0, 0 end,
	-- Let x define where the center of the text will be
	center = function(t, f) return f:getWidth(t)/2, 0 end,

	-- Let x, y define where the center of the text will be
	middle = function(t, f) return f:getWidth(t)/2, f:getHeight()/2 end
}
function utils.jPrint(text, justify, x, y, font)

	assert(jMap[justify], ("%s is not a valid justify option."):format(justify))

	love.graphics.push("all")

	local font = utils.setFont(font)
	local ox, oy = jMap[justify](text, font)

	utils.lgprint(text, x, y, 0, 1, 1, ox, oy)

	love.graphics.pop()

end

function utils.centerText(text, start, finish)
	-- return centered x between start and finish
	-- start is the x position of the left point
	-- finish is the x position of the right point
	-- this will not prevent spilling of text outside those bounds
	if not start then start = 0 end
	if not finish then finish = love.graphics.getWidth() end
	return math.floor(
		start + (finish - start) / 2 - love.graphics.getFont():getWidth(text) / 2
	)
end

function utils.hcPrint(text, y, font)
	if font then utils.setFont(font) end
	utils.lgprint(text, utils.centerText(text), y)
end

-- function utils.vcPrint(text, x, font)
-- 	if font then utils.setFont(font) end
-- 	utils.lgprint(text, x, )
-- end

function utils.mPrint(text, x, y, font)
	-- middle print.  Center text on x/y coords

	utils.jPrint(text, "middle", x, y, font)
end

function utils.listPrint(list, x, y, font, gap)

	-- Takes a list of things to print and prints it at x, y
	-- With a new line between them.

	love.graphics.push("all")
	if font then utils.setFont(font) end
	local font = love.graphics.getFont()
	gap = gap or 5
	for i, v in ipairs(list) do
		utils.lgprint(v, x, y * i + (i*gap))
	end
	love.graphics.pop()
end

function utils.individualListPrint(text, i, x, y, font, gap)

	-- prints like listPrint does, except with individual lines
	-- doesn't need prior lines to work,
	--@ i represents which line is being passed

	love.graphics.push("all")
	if font then utils.setFont(font) end
	local font = love.graphics.getFont()
	gap = gap or 5
	utils.lgprint(text, x, y + (i-1) * font:getHeight() + gap)
	love.graphics.pop()
end

function utils.capitalize(text)
	return text:gsub("^%l", string.upper)
end

function utils.replaceChar(str, pos, to)
	-- the +1 is so -1 means last char
	if pos < 0 then pos = str:len() + (pos + 1) end
	return str:sub(1, pos - 1) .. to .. str:sub(pos + 1, str:len())
end

return utils
