--[[

     My Minimal Theme

--]]

local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local theme_assets = require("beautiful.theme_assets")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme = {}

theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes/my_minimal"
theme.wallpaper = theme.confdir .. "/wallpaper.jpg"
--theme.wallpaper = theme.confdir .. "/wall2.jpeg"
--theme.wallpaper = theme.confdir .. "/wall3.jpg"

--theme.font = "Terminus 8"
theme.font = "FiraMono Nerd Font 8"

--theme.bg_normal = "#000000"
--theme.bg_focus = "#000000"
--theme.bg_urgent = "#000000"
theme.bg_normal = "#222222"
theme.bg_focus = "#535d6c"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

--theme.fg_normal = "#aaaaaa"
--theme.fg_focus = "#ff8c00"
--theme.fg_urgent = "#af1d18"
--theme.fg_minimize = "#ffffff"
theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

--theme.border_width = dpi(1)
--theme.border_normal = "#1c2022"
--theme.border_focus = "#606060"
--theme.border_marked = "#3ca4d8"
theme.useless_gap = dpi(0)
theme.border_width = dpi(1)
theme.border_normal = "#000000"
theme.border_focus = "#535d6c"
theme.border_marked = "#91231c"

theme.menu_border_width = 0
theme.menu_width = dpi(100)
theme.menu_height = dpi(15)
--theme.menu_submenu_icon = theme.confdir .. "/icons/submenu.png"
theme.menu_submenu_icon = themes_path .. "default/submenu.png"

--theme.menu_fg_normal = "#aaaaaa"
--theme.menu_fg_focus = "#ff8c00"
--theme.menu_bg_normal = "#050505dd"
--theme.menu_bg_focus = "#050505dd"

--theme.widget_temp = theme.confdir .. "/icons/temp.png"
--theme.widget_uptime = theme.confdir .. "/icons/ac.png"
--theme.widget_cpu = theme.confdir .. "/icons/cpu.png"
--theme.widget_weather = theme.confdir .. "/icons/dish.png"
--theme.widget_fs = theme.confdir .. "/icons/fs.png"
--theme.widget_mem = theme.confdir .. "/icons/mem.png"
--theme.widget_note = theme.confdir .. "/icons/note.png"
--theme.widget_note_on = theme.confdir .. "/icons/note_on.png"
--theme.widget_netdown = theme.confdir .. "/icons/net_down.png"
--theme.widget_netup = theme.confdir .. "/icons/net_up.png"
--theme.widget_mail = theme.confdir .. "/icons/mail.png"
--theme.widget_batt = theme.confdir .. "/icons/bat.png"
--theme.widget_clock = theme.confdir .. "/icons/clock.png"
--theme.widget_vol = theme.confdir .. "/icons/spkr.png"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
--theme.taglist_squares_sel = theme.confdir .. "/icons/square_a.png"
--theme.taglist_squares_unsel = theme.confdir .. "/icons/square_b.png"

theme.tasklist_plain_task_name = false
theme.tasklist_disable_task_name = true
theme.tasklist_disable_icon = false

theme.useless_gap = 0

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"
--theme.layout_tile = theme.confdir .. "/icons/tile.png"
--theme.layout_tilegaps = theme.confdir .. "/icons/tilegaps.png"
--theme.layout_tileleft = theme.confdir .. "/icons/tileleft.png"
--theme.layout_tilebottom = theme.confdir .. "/icons/tilebottom.png"
--theme.layout_tiletop = theme.confdir .. "/icons/tiletop.png"
--theme.layout_fairv = theme.confdir .. "/icons/fairv.png"
--theme.layout_fairh = theme.confdir .. "/icons/fairh.png"
--theme.layout_spiral = theme.confdir .. "/icons/spiral.png"
--theme.layout_dwindle = theme.confdir .. "/icons/dwindle.png"
--theme.layout_max = theme.confdir .. "/icons/max.png"
--theme.layout_fullscreen = theme.confdir .. "/icons/fullscreen.png"
--theme.layout_magnifier = theme.confdir .. "/icons/magnifier.png"
--theme.layout_floating = theme.confdir .. "/icons/floating.png"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"
--theme.titlebar_close_button_normal = theme.confdir .. "/icons/titlebar/close_normal.png"
--theme.titlebar_close_button_focus = theme.confdir .. "/icons/titlebar/close_focus.png"
--theme.titlebar_minimize_button_normal = theme.confdir .. "/icons/titlebar/minimize_normal.png"
--theme.titlebar_minimize_button_focus = theme.confdir .. "/icons/titlebar/minimize_focus.png"
--theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/icons/titlebar/ontop_normal_inactive.png"
--theme.titlebar_ontop_button_focus_inactive = theme.confdir .. "/icons/titlebar/ontop_focus_inactive.png"
--theme.titlebar_ontop_button_normal_active = theme.confdir .. "/icons/titlebar/ontop_normal_active.png"
--theme.titlebar_ontop_button_focus_active = theme.confdir .. "/icons/titlebar/ontop_focus_active.png"
--theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/icons/titlebar/sticky_normal_inactive.png"
--theme.titlebar_sticky_button_focus_inactive = theme.confdir .. "/icons/titlebar/sticky_focus_inactive.png"
--theme.titlebar_sticky_button_normal_active = theme.confdir .. "/icons/titlebar/sticky_normal_active.png"
--theme.titlebar_sticky_button_focus_active = theme.confdir .. "/icons/titlebar/sticky_focus_active.png"
--theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/icons/titlebar/floating_normal_inactive.png"
--theme.titlebar_floating_button_focus_inactive = theme.confdir .. "/icons/titlebar/floating_focus_inactive.png"
--theme.titlebar_floating_button_normal_active = theme.confdir .. "/icons/titlebar/floating_normal_active.png"
--theme.titlebar_floating_button_focus_active = theme.confdir .. "/icons/titlebar/floating_focus_active.png"
--theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/icons/titlebar/maximized_normal_inactive.png"
--theme.titlebar_maximized_button_focus_inactive = theme.confdir .. "/icons/titlebar/maximized_focus_inactive.png"
--theme.titlebar_maximized_button_normal_active = theme.confdir .. "/icons/titlebar/maximized_normal_active.png"
--theme.titlebar_maximized_button_focus_active = theme.confdir .. "/icons/titlebar/maximized_focus_active.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- {{{ Widgets }}}
local widgets = {}

-- Seperator
widgets.sep = wibox.widget.textbox(" | ")

-- Textclock
--os.setlocale(os.getenv("LANG")) -- to localize the clock
--widgets.textclock = wibox.widget.textclock({
--format = "%a %b %d, %H:%M",
--font = theme.font,
--})
widgets.textclock = wibox.widget.textclock()

-- Calendar
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
widgets.calendar = calendar_widget({
	theme = "nord",
	start_sunday = true,
	placement = "top_right",
})

-- Attach calendar to clock
widgets.textclock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		widgets.calendar.toggle()
	end
end)

-- Battery
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
widgets.battery = battery_widget()

-- Volume
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
widgets.volume = volume_widget({
	widget_type = "icon_and_text",
})

-- Brightness
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
widgets.brightness = brightness_widget({
	type = "icon_and_text",
	program = "brightnessctl",
	base = 50,
	percentage = true,
	rmb_set_max = true,
	font = theme.font,
})

-- Logout menu
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
widgets.logout_menu = logout_menu_widget()

-- Spotify
--local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
--widgets.spotify = spotify_widget()

-- Launcher
widgets.launcher = awful.widget.launcher({
	image = theme.awesome_icon,
	menu = awful.util.mymainmenu, -- this might error because we get them before awful.util.mymainmenu exists
})

function theme.at_screen_connect(s)
	-- Quake application
	s.quake = lain.util.quake({ app = awful.util.terminal })

	-- If wallpaper is a function, call it with the screen
	local wallpaper = theme.wallpaper
	if type(wallpaper) == "function" then
		wallpaper = wallpaper(s)
	end
	gears.wallpaper.maximized(wallpaper, s, true)

	-- Tags
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(my_table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 2, function()
			awful.layout.set(awful.layout.layouts[1])
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
	s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = dpi(19), -- maybe play with this
		bg = theme.bg_normal,
		fg = theme.fg_normal,
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			--s.mylayoutbox,
			widgets.launcher,
			s.mytaglist,
			s.mypromptbox,
		},
		s.mytasklist, -- Middle widget
		--nil,
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			--spacing = 10,
			--spacing_widget = {
			--	widget = wibox.widget.textbox("|"),
			--},
			s.mylayoutbox,
			widgets.sep,
			wibox.widget.systray(),
			--widgets.sep,
			--widgets.spotify,
			--widgets.sep,
			widgets.brightness,
			widgets.sep,
			widgets.volume,
			widgets.sep,
			widgets.battery,
			widgets.sep,
			widgets.textclock,
			widgets.sep,
			widgets.logout_menu,
		},
	})

	--[[
	-- Create the bottom wibox
	s.mybottomwibox = awful.wibar({
		position = "bottom",
		screen = s,
		border_width = 0,
		height = dpi(20),
		bg = theme.bg_normal,
		fg = theme.fg_normal,
	})

	-- Add widgets to the bottom wibox
	s.mybottomwibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			s.mylayoutbox,
		},
	})
	--]]
end

return theme
