--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
--local menubar       = require("menubar")
local freedesktop = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility

-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false

	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end

		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})

		in_error = false
	end)
end

-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
	end
end

run_once({ "urxvtd", "unclutter -root" }) -- comma-separated entries

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions

local themes = require("themes.themes")
local chosen_theme = themes.my_minimal

RC = {}
RC.programs = require("main.programs")
RC.keys = require("main.keys")

-- Keys
local super = RC.keys.super
local alt = RC.keys.alt
local ctrl = RC.keys.ctrl
local shift = RC.keys.shift
local esc = RC.keys.esc

-- Programs
local programs = RC.programs

local vi_focus = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev = true -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274

awful.util.terminal = programs.terminal
--awful.util.tagnames = { "1", "2", "3", "4", "5" }
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
awful.layout.layouts = {
	--awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	--awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	--awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	--awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	--awful.layout.suit.corner.nw,
	--awful.layout.suit.corner.ne,
	--awful.layout.suit.corner.sw,
	--awful.layout.suit.corner.se,
	--lain.layout.cascade,
	--lain.layout.cascade.tile,
	--lain.layout.centerwork,
	--lain.layout.centerwork.horizontal,
	--lain.layout.termfair,
	--lain.layout.termfair.center
}

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

awful.util.taglist_buttons = mytable.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ super }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ super }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

awful.util.tasklist_buttons = mytable.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
local myawesomemenu = {
	{
		"Hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "Manual", string.format("%s -e man awesome", programs.terminal) },
	{ "Edit config", string.format("%s -e %s %s", programs.terminal, programs.editor, awesome.conffile) },
	{ "Restart", awesome.restart },
	{
		"Quit",
		function()
			awesome.quit()
		end,
	},
}

awful.util.mymainmenu = freedesktop.menu.build({
	before = {
		{ "Awesome", myawesomemenu, beautiful.awesome_icon },
		-- other triads can be put here
	},
	after = {
		{ "Open terminal", programs.terminal },
		-- other triads can be put here
	},
})

-- Hide the menu when the mouse leaves it
awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
	if
		not awful.util.mymainmenu.active_child
		or (
			awful.util.mymainmenu.wibox ~= mouse.current_wibox
			and awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox
		)
	then
		awful.util.mymainmenu:hide()
	else
		awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave", function()
			if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
				awful.util.mymainmenu:hide()
			end
		end)
	end
end)

-- Set the Menubar terminal for applications that require it
--menubar.utils.terminal = terminal

-- }}}

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
	local only_one = #s.tiled_clients == 1
	for _, c in pairs(s.clients) do
		if only_one and not c.floating or c.maximized or c.fullscreen then
			c.border_width = 0
		else
			c.border_width = beautiful.border_width
		end
	end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
end)

-- }}}

-- {{{ Mouse bindings

root.buttons(mytable.join(
	awful.button({}, 3, function()
		awful.util.mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings

globalkeys = mytable.join(
	-- {{{ Launchers

	-- Terminal
	awful.key({ super }, "Return", function()
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
		awful.spawn(programs.discord)
	end, { description = "open discord (personal)", group = "launcher" }),

	-- Slack (work)
	awful.key({ super }, "w", function()
		awful.spawn(programs.slack)
	end, { description = "open slack (work)", group = "launcher" }),

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

	awful.key({ super, shift }, "w", function()
		awful.util.mymainmenu:show()
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
	awful.key({ ctrl, shift }, "b", function()
		for s in screen do
			--if s.mywibox.visible then
			--	lain.util.useless_gaps_resize(4)
			--else
			--	lain.util.useless_gaps_resize(-4)
			--end
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
	-- awful.key({}, "XF86AudioRaiseVolume", function()
	-- 	awful.util.spawn("amixer set Master 5%+")
	-- end, { description = "raise volume", group = "hotkeys" }),
	awful.key({ super }, "]", function()
		awful.util.spawn("amixer set Master 5%+")
	end, { description = "raise volume", group = "hotkeys" }),

	-- awful.key({}, "XF86AudioLowerVolume", function()
	-- 	awful.util.spawn("amixer set Master 5%-")
	-- end, { description = "lower volume", group = "hotkeys" }),
	awful.key({ super }, "[", function()
		awful.util.spawn("amixer set Master 5%-")
	end, { description = "lower volume", group = "hotkeys" }),

	awful.key({}, "XF86AudioMute", function()
		awful.util.spawn("amixer sset Master toggle")
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

	-- }}}
)

clientkeys = mytable.join(
	awful.key({ alt, shift }, "m", lain.util.magnify_client, { description = "magnify client", group = "client" }),
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
	awful.key({ super, ctrl }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ super }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ super, shift }, "t", function(c)
		c.sticky = not c.sticky
	end, { description = "toggle sticky", group = "client" }),
	awful.key({ super }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	-- TODO: figure out a better bind
	awful.key({ super }, "a", function(c)
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

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
--
-- Keycodes can be found using the program `xev`
--
for i = 1, 10 do
	globalkeys = mytable.join(
		globalkeys,
		-- View tag only.
		awful.key({ super }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ super, ctrl }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ super, shift }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ super, ctrl, shift }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = mytable.join(
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

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			callback = awful.client.setslave,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			size_hints_honor = false,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = { "normal", "dialog" },
		},
		properties = { titlebars_enabled = false },
	},

	-- Find a client's class using `xprop`

	-- Set Firefox to always map on the tag named "1"
	{
		rule = { class = "firefox" },
		--properties = { screen = 1, tag = "1" },
		properties = { tag = "1" },
	},

	-- Set Obsidian to always map on the tag named "3"
	{
		rule = { class = "obsidian" },
		--properties = { screen = 1, tag = "3" },
		properties = { tag = "3" },
	},

	-- Set Spotify to always map on the tag named "9"
	{
		rule = { class = "Spotify" },
		--properties = { screen = 1, tag = "9" },
		properties = { tag = "9" },
	},

	-- Set Discord to always map on the tag named "10"
	{
		rule = { class = "discord" },
		--properties = { screen = 1, tag = "10" },
		properties = { tag = "10" },
	},

	-- Set Slack to always map on the tag named "8"
	{
		rule = { class = "Slack" },
		--properties = { screen = 1, tag = "8" },
		properties = { tag = "8" },
	},
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- Custom
	if beautiful.titlebar_fun then
		beautiful.titlebar_fun(c)
		return
	end

	-- Default
	-- buttons for the titlebar
	local buttons = mytable.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c, { size = 16 }):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- switch to parent after closing child window
local function backham()
	local s = awful.screen.focused()
	local c = awful.client.focus.history.get(s, 0)
	if c then
		client.focus = c
		c:raise()
	end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- }}}

-- {{{ Autostart }}}
awful.spawn.with_shell("compton")
