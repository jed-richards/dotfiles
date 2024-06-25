-- [[
--
-- Some of these programs are Flatpaks, so after installing I linked the
-- binary to the global bin, so I don't have to do:
--
-- ```
-- flatpak run com.discordapp.Discord
-- ```
--
-- I linked to /usr/bin by doing:
--
-- ```
-- sudo ln -sf ~/.local/share/flatpak/exports/bin/com.discordapp.Discord /usr/bin/discord
-- ```
--
-- Then I can launch discord by typing `discord`
--
-- ]]

local M = {
	terminal = "kitty",
	browser = "firefox",
	editor = os.getenv("EDITOR") or "nvim",
	music = "spotify", -- flatpak
	notes = "obsidian", -- flatpak
	discord = "discord", -- flatpak
	slack = "slack", -- flatpak
}

return M
