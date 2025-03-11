local wezterm = require("wezterm")
local utils = require("lua.utils")

local function build_wt_font_config()
	return {
		font = wezterm.font_with_fallback({
			"JetBrains Mono",
			"Symbols Nerd Font",
		}),
		font_size = 12,
	}
end

local C = {
	adjust_window_size_when_changing_font_size = false,
}

return utils.deep_extend("force", C, build_wt_font_config())
