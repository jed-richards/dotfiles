local M = {}

local colors = {
	"Catppuccin Macchiato",
	"Catppuccin Mocha",
	"Galaxy",
	"Lavandula",
	"Material Palenight (base16)",
	"Mirage",
	"Night Owl (Gogh)",
	"Snazzy",
	"Snazzy (base16)",
	"Solar Flare (base16)",
	"Solarized (dark) (terminal.sexy)",
	"Sublette",
	"Tokyo Night",
	"Tokyo Night Moon",
	"Tokyo Night Storm",
	"Tokyo Night Storm (Gogh)",
	"catppuccin-macchiato",
	"catppuccin-mocha",
	"tokyonight",
	"tokyonight-storm",
	"tokyonight_moon",
}

table.sort(colors)

local current_color = 1

M.change_color = function(direction)
	if direction == "next" then
		if current_color == #colors then
			current_color = 0
		end
		current_color = current_color + 1
	elseif direction == "prev" then
		if current_color == 1 then
			current_color = #colors + 1
		end
		current_color = current_color - 1
	end

	return colors[current_color]
end

return M
