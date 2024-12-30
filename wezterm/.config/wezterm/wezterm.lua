local wezterm = require("wezterm")
local color_picker = require("commands.color_picker")
local action = wezterm.action
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("FiraMono Nerd Font")
config.font_size = 12

-- Disable tab bar
config.enable_tab_bar = false

-- Remove padding from window
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

wezterm.on("change-color-next", function(window, pane)
	local color = color_picker.change_color("next")
	window:set_config_overrides({
		color_scheme = color,
	})
end)

wezterm.on("change-color-prev", function(window, pane)
	local color = color_picker.change_color("prev")
	window:set_config_overrides({
		color_scheme = color,
	})
end)

config.keys = {
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = action.EmitEvent("change-color-next"),
	},
	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = action.EmitEvent("change-color-prev"),
	},
}

return config
