-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local M = {}
local super = RC.keys.super

function M.get()
	local clientbuttons = gears.table.join(
		awful.button({}, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
		end),
		awful.button({ super }, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({ super }, 3, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	return clientbuttons
end

return setmetatable({}, {
	__call = function(_, ...)
		return M.get(...)
	end,
})
