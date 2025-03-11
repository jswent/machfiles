local wezterm = require("wezterm")

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "tokyonight_custom"
	else
		return "tokyonight_day_custom"
	end
end

return {
	color_scheme_dirs = { "/Users/jswent/.config/wezterm/colors" },
	color_scheme = scheme_for_appearance(get_appearance()),
}
