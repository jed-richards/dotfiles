local wezterm = require("wezterm")

-- Construct config
local config = wezterm.config_builder()

-- Set color scheme
config.color_scheme = "Catppuccin Macchiato"

-- Set font
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

return config
