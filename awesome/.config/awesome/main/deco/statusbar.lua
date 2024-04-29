-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
	wallpaper = require("main.deco.wallpaper"),
	taglist = require("main.deco.taglist"),
	tasklist = require("main.deco.tasklist"),
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create keyboardlayout widget
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create battery widget
-- local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
--local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

-- Create brightness widget
--local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, RC.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			RC.launcher,
			s.mytaglist,
			s.mypromptbox,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			mykeyboardlayout,
			wibox.widget.systray(),
			mytextclock,
			--brightness_widget({
			--	type = "arc",
			--	program = "xbacklight",
			--	step = 5,
			--	base = 50,
			--	rmb_set_max = true,
			--}),
			--batteryarc_widget({
			--	show_current_level = true,
			--	arc_thickness = 1,
			--	size = 24,
			--}),
			s.mylayoutbox,
		},
	})
end)
-- }}}
