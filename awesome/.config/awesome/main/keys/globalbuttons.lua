-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local M = {}

function M.get()
	-- Mouse bindings
	local globalbuttons = gears.table.join(
		awful.button({}, 3, function()
			RC.mainmenu:toggle()
		end),
		awful.button({}, 4, awful.tag.viewnext),
		awful.button({}, 5, awful.tag.viewprev)
	)

	return globalbuttons
end

return setmetatable({}, {
	__call = function(_, ...)
		return M.get(...)
	end,
})
