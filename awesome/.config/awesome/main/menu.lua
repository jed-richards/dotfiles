-- Standard awesome library
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Theme handling library
local beautiful = require("beautiful")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

local terminal = RC.programs.terminal
local editor = RC.programs.editor
local editor_cmd = terminal .. " -e " .. editor

local M = {
	awesome = {
		{
			"Hotkeys",
			function()
				hotkeys_popup.show_help(nil, awful.screen.focused())
			end,
		},
		{ "Manual", terminal .. " -e man awesome" },
		{ "Edit Config", editor_cmd .. " " .. awesome.conffile },
		{ "Restart", awesome.restart },
		{
			"Quit",
			function()
				awesome.quit()
			end,
		},
	},

	favorite = {},
} -- menu

local _M = {} -- module

function _M.get()
	--local main_menu
	--if has_fdo then
	--	main_menu = freedesktop.menu.build({
	--		before = { "Awesome", M.awesome, beautiful.awesome_icon },
	--		after = {
	--			{ "Open terminal", terminal },
	--			{ "Restart", awesome.restart },
	--			{
	--				"Quit",
	--				function()
	--					awesome.quit()
	--				end,
	--			},
	--		},
	--	})
	--else
	--	main_menu = awful.menu({
	--		items = {
	--			{ "Awesome", M.awesome, beautiful.awesome_icon },
	--			{ "Debian", debian.menu.Debian_menu.Debian },
	--			{ "Open terminal", terminal },
	--		},
	--	})
	--end

	local main_menu = awful.menu({
		items = {
			{ "Awesome", M.awesome, beautiful.awesome_icon },
			{ "Debian", debian.menu.Debian_menu.Debian },
			{ "Open terminal", terminal },
		},
	})

	return main_menu
end

return setmetatable({}, {
	__call = function(_, ...)
		return _M.get(...)
	end,
})
