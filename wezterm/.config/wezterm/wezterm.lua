local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("FiraMono Nerd Font")

return config
