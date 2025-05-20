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

-- Define a table of window_padding settings to be reused
local padding = {
	default = {
		left = "1cell",
		right = "1cell",
		top = "0.5cell",
		bottom = "0.5cell",
	},
	tui = {
		left = 0,
		right = 0,
		top = "0.25cell",
		bottom = 0,
	},
	none = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}

-- Define a table of programs and their corresponding padding settings
local program_padding = {
	nvim = padding.tui,
	yazi = padding.tui,
}

wezterm.on("update-status", function(window, pane)
	local process_name = pane:get_foreground_process_name()
	if process_name then
		local padding_setting = program_padding[process_name:match("[^/]+$")]
		if padding_setting then
			window:set_config_overrides({ window_padding = padding_setting })
		else
			window:set_config_overrides({ window_padding = padding.default })
		end
	end
end)

local C = {
	window_padding = padding.default,
	default_cursor_style = "BlinkingBar",
	window_decorations = "RESIZE",
	max_fps = 120,
	set_environment_variables = {
		TRANSPARENT = "true",
	},
}

return utils.deep_extend("force", C, ui_for_appearance(get_appearance()))
