local wezterm = require("wezterm")
local utils = require("lua.utils")

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function ui_for_appearance(appearance)
	if appearance:find("Dark") then
		return {
			window_background_opacity = 0.8,
			macos_window_background_blur = 32,
		}
	else
		return {
			window_background_opacity = 0.9,
			macos_window_background_blur = 16,
		}
	end
end

local C = {
	window_padding = {
		left = 20,
		right = 10,
		top = 20,
		bottom = 10,
	},
	default_cursor_style = "BlinkingBar",
	window_decorations = "RESIZE",
}

return utils.deep_extend("force", C, ui_for_appearance(get_appearance()))
