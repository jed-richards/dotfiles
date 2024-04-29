-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Menubar library
local menubar = require("menubar")

-- Keys
local super = RC.keys.super
local alt = RC.keys.alt
local ctrl = RC.keys.ctrl
local shift = RC.keys.shift
local esc = RC.keys.esc

-- Programs
local programs = RC.programs

local M = {}

function M.get()
	local globalkeys = gears.table.join(

		-- {{{ Launchers

		-- Terminal
		awful.key({ super }, "Enter", function()
			awful.spawn(programs.terminal)
		end, { description = "open a terminal", group = "launcher" }),

		-- Browser (firefox)
		awful.key({ super }, "b", function()
			awful.spawn(programs.browser)
		end, { description = "open a browser", group = "launcher" }),

		-- Music (spotify)
		awful.key({ super }, "m", function()
			awful.spawn(programs.music)
		end, { description = "open music", group = "launcher" }),

		-- Notes (obsidian)
		awful.key({ super }, "o", function()
			awful.spawn(programs.notes)
		end, { description = "open notes (obsidian)", group = "launcher" }),

		-- Discord (personal)
		awful.key({ super }, "p", function()
			awful.spawn(programs.notes)
		end, { description = "open discord (personal)", group = "launcher" }),

		-- TODO: maybe switch to dmenu or rofi (Run prompt)
		awful.key({ super }, "r", function()
			awful.screen.focused().mypromptbox:run()
		end, { description = "run prompt", group = "launcher" }),

		-- }}}

		-- {{{ AwesomeWM stuff

		awful.key({ super }, "s", hotkeys_popup.show_help, {
			description = "show help",
			group = "awesome",
		}),

		awful.key({ super }, "w", function()
			RC.mainmenu:show()
		end, { description = "show main menu", group = "awesome" }),

		awful.key({ super, shift }, "r", awesome.restart, {
			description = "reload awesome",
			group = "awesome",
		}),

		awful.key({ super, shift }, "q", awesome.quit, {
			description = "quit awesome",
			group = "awesome",
		}),

		-- Show/hide wibox
		awful.key({ super }, "b", function()
			for s in screen do
				s.mywibox.visible = not s.mywibox.visible
				if s.mybottomwibox then
					s.mybottomwibox.visible = not s.mybottomwibox.visible
				end
			end
		end, { description = "toggle wibox", group = "awesome" }),

		-- }}}

		-- {{{ Tag stuff

		-- Like <ctrl-b> - o in Tmux
		awful.key({ super }, esc, awful.tag.history.restore, { description = "go back", group = "tag" }),

		-- Cycle through tags
		awful.key({ super }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
		awful.key({ super }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

		-- Cycle through non-empty tags
		awful.key({ alt }, "Left", function()
			lain.util.tag_view_nonempty(-1)
		end, { description = "view  previous nonempty", group = "tag" }),
		awful.key({ alt }, "Right", function()
			lain.util.tag_view_nonempty(1)
		end, { description = "view  previous nonempty", group = "tag" }),

		--[[ 
		-- Dynamic tags
		-- These are cool! But idk if I would use them. Maybe!
	
		awful.key({ super, shift }, "n", function()
			lain.util.add_tag()
		end, { description = "add new tag", group = "tag" }),
		awful.key({ super, shift }, "r", function()
			lain.util.rename_tag()
		end, { description = "rename tag", group = "tag" }),
		awful.key({ super, shift }, "Left", function()
			lain.util.move_tag(-1)
		end, { description = "move tag to the left", group = "tag" }),
		awful.key({ super, shift }, "Right", function()
			lain.util.move_tag(1)
		end, { description = "move tag to the right", group = "tag" }),
		awful.key({ super, shift }, "d", function()
			lain.util.delete_tag()
		end, { description = "delete tag", group = "tag" }),

		--]]

		-- }}}

		-- {{{ Client stuff

		--------------------------------------------------------------------------------
		-- Default client focus
		awful.key({ alt }, "j", function()
			awful.client.focus.byidx(1)
		end, { description = "focus next by index", group = "client" }),

		awful.key({ alt }, "k", function()
			awful.client.focus.byidx(-1)
		end, { description = "focus previous by index", group = "client" }),

		awful.key({ alt, shift }, "j", function()
			awful.client.swap.byidx(1)
		end, { description = "swap with next client by index", group = "client" }),

		awful.key({ alt, shift }, "k", function()
			awful.client.swap.byidx(-1)
		end, { description = "swap with previous client by index", group = "client" }),

		-- By-direction client focus
		awful.key({ super }, "j", function()
			awful.client.focus.global_bydirection("down")
			if client.focus then
				client.focus:raise()
			end
		end, { description = "focus down", group = "client" }),

		awful.key({ super }, "k", function()
			awful.client.focus.global_bydirection("up")
			if client.focus then
				client.focus:raise()
			end
		end, { description = "focus up", group = "client" }),

		awful.key({ super }, "h", function()
			awful.client.focus.global_bydirection("left")
			if client.focus then
				client.focus:raise()
			end
		end, { description = "focus left", group = "client" }),

		awful.key({ super }, "l", function()
			awful.client.focus.global_bydirection("right")
			if client.focus then
				client.focus:raise()
			end
		end, { description = "focus right", group = "client" }),
		--------------------------------------------------------------------------------

		awful.key({ super }, "u", awful.client.urgent.jumpto, {
			description = "jump to urgent client",
			group = "client",
		}),

		awful.key({ super }, "Tab", function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end, { description = "go back", group = "client" }),

		awful.key({ super, ctrl }, "n", function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal("request::activate", "key.unminimize", { raise = true })
			end
		end, { description = "restore minimized", group = "client" }),

		-- }}}

		-- {{{ Screen stuff

		awful.key({ super, ctrl }, "j", function()
			awful.screen.focus_relative(1)
		end, { description = "focus the next screen", group = "screen" }),

		awful.key({ super, ctrl }, "k", function()
			awful.screen.focus_relative(-1)
		end, { description = "focus the previous screen", group = "screen" }),

		-- }}}

		-- {{{ Layout stuff

		-- Resize master
		awful.key({ super, alt }, "l", function()
			awful.tag.incmwfact(0.05)
		end, { description = "increase master width factor", group = "layout" }),

		awful.key({ super, alt }, "h", function()
			awful.tag.incmwfact(-0.05)
		end, { description = "decrease master width factor", group = "layout" }),

		-- Change number of master clients
		awful.key({ super, shift }, "h", function()
			awful.tag.incnmaster(1, nil, true)
		end, { description = "increase the number of master clients", group = "layout" }),

		awful.key({ super, shift }, "l", function()
			awful.tag.incnmaster(-1, nil, true)
		end, { description = "decrease the number of master clients", group = "layout" }),

		-- Change number of columns
		awful.key({ super, ctrl }, "h", function()
			awful.tag.incncol(1, nil, true)
		end, { description = "increase the number of columns", group = "layout" }),

		awful.key({ super, ctrl }, "l", function()
			awful.tag.incncol(-1, nil, true)
		end, { description = "decrease the number of columns", group = "layout" }),

		-- Change layout setting
		awful.key({ super }, "space", function()
			awful.layout.inc(1)
		end, { description = "select next", group = "layout" }),

		awful.key({ super, shift }, "space", function()
			awful.layout.inc(-1)
		end, { description = "select previous", group = "layout" }),

		-- }}}

		-- {{{ Utilities

		-- Volume
		awful.key({}, "XF86AudioRaiseVolume", function()
			awful.util.spawn("amixer set Master 5%+")
			beautiful.volume.update()
		end, { description = "raise volume", group = "hotkeys" }),

		awful.key({}, "XF86AudioLowerVolume", function()
			awful.util.spawn("amixer set Master 5%-")
			beautiful.volume.update()
		end, { description = "lower volume", group = "hotkeys" }),

		awful.key({}, "XF86AudioMute", function()
			awful.util.spawn("amixer sset Master toggle")
			beautiful.volume.update()
		end),

		-- Screen brightness
		awful.key({}, "XF86MonBrightnessUp", function()
			awful.util.spawn("xbacklight -inc 10")
		end, { description = "raise brightness", group = "hotkeys" }),

		awful.key({}, "XF86MonBrightnessDown", function()
			awful.util.spawn("xbacklight -dec 10")
		end, { description = "lower brightness", group = "hotkeys" }),

		-- Screenshot
		awful.key({}, "Print", function()
			awful.util.spawn("flameshot full")
		end, { description = "take a screenshot", group = "hotkeys" })

		--[[
		-- TODO: add something like this
		--
		-- X screen locker
		awful.key({ alt, ctrl }, "l", function()
			os.execute(scrlocker)
		end, { description = "lock screen", group = "hotkeys" }),
		--]]

		-- }}}

		-- {{{ Widgets stuff

		--[[
		awful.key({ alt }, "c", function()
			if beautiful.cal then
				beautiful.cal.show(7)
			end
		end, { description = "show calendar", group = "widgets" }),
		awful.key({ alt }, "h", function()
			if beautiful.fs then
				beautiful.fs.show(7)
			end
		end, { description = "show filesystem", group = "widgets" }),
		awful.key({ alt }, "w", function()
			if beautiful.weather then
				beautiful.weather.show(7)
			end
		end, { description = "show weather", group = "widgets" })
		--]]

		-- }}}
	)

	return globalkeys
end

return setmetatable({}, {
	__call = function(_, ...)
		return M.get(...)
	end,
})
