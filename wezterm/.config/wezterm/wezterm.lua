local wezterm = require("wezterm")

-- Construct config
local config = wezterm.config_builder()

-- Set color scheme
config.color_scheme = "Catppuccin Macchiato"

-- Set font
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12

-- Set character variants for font
config.harfbuzz_features = {
	"cv10", -- Changes variant of char `l` (cv07-10)
	"ss02", -- Changes variant of `<=` and `>=` ligatures
	"zero", -- Change variant of char `0` (zero, cv11-13)
	"cv14", -- Change variant of char `3`
	"ss03", -- Change variant of char `&`
}

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
