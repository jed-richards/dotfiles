-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Keys
local super = RC.keys.super
local alt = RC.keys.alt
local ctrl = RC.keys.ctrl
local shift = RC.keys.shift

local M = {}

function M.get()
	local clientkeys = gears.table.join(
		awful.key({ super }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "toggle fullscreen", group = "client" }),

		awful.key({ super }, "q", function(c)
			c:kill()
		end, { description = "close", group = "client" }),

		awful.key(
			{ super, ctrl },
			"space",
			awful.client.floating.toggle,
			{ description = "toggle floating", group = "client" }
		),

		awful.key({ super, ctrl }, "Return", function(c)
			c:swap(awful.client.getmaster())
		end, { description = "move to master", group = "client" }),

		awful.key({ super }, "o", function(c)
			c:move_to_screen()
		end, { description = "move to screen", group = "client" }),

		awful.key({ super }, "t", function(c)
			c.ontop = not c.ontop
		end, { description = "toggle keep on top", group = "client" }),

		awful.key({ super }, "n", function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end, { description = "minimize", group = "client" }),

		awful.key({ super }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "(un)maximize", group = "client" }),

		awful.key({ super, ctrl }, "m", function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end, { description = "(un)maximize vertically", group = "client" }),

		awful.key({ super, shift }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end, { description = "(un)maximize horizontally", group = "client" })
	)

	return clientkeys
end

return setmetatable({}, {
	__call = function(_, ...)
		return M.get(...)
	end,
})
