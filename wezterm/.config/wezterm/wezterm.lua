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
	"zero", -- Change variant of char `0` (zero, cv11-13)
	"cv14", -- Change variant of char `3`
	"ss03", -- Change variant of char `&`

	-- Disables ligatures in most fonts
	"calt=0",
	"clig=0",
	"liga=0",

	-- Ligatures
	"ss02", -- Changes variant of `<=` and `>=` ligatures
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

config.window_background_opacity = 0.8

-- toggle function
wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		-- if no override is setup, override the default opacity value with 1.0
		overrides.window_background_opacity = 1.0
	else
		-- if there is an override, make it nil so the opacity goes back to the default
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

config.keys = {
	{
		key = "o",
		mods = "ALT",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
}

return config
