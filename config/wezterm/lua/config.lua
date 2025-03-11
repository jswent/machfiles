local wezterm = require("wezterm")
local utils = require("lua.utils")

local M = {}

local function get_config_modules()
	local modules = {}
	local config_dir = wezterm.home_dir .. "/.config/wezterm/config/"

	for _, file in ipairs(wezterm.glob(config_dir .. "*.lua")) do
		local module_name = file:gsub(config_dir, ""):gsub("%.lua$", "")
		table.insert(modules, "config." .. module_name)
	end

	return modules
end

function M.setup()
	local config = wezterm.config_builder()

	local loaded_modules = {}

	local function load_config(module_name)
		if loaded_modules[module_name] then
			wezterm.log_info("Module already loaded: " .. module_name)
			return
		end

		local success, module = pcall(require, module_name)
		if success and type(module) == "table" then
			for k, v in pairs(module) do
				config[k] = v
			end
			loaded_modules[module_name] = true
		else
			wezterm.log_error("Failed to load module: " .. module_name)
		end
	end

	-- Find and load all modules in the config directory
	local modules = get_config_modules()
	for _, module_name in ipairs(modules) do
		load_config(module_name)
	end

	return {
		load_config = load_config,
		tbl_deep_extend = tbl_deep_extend,
	}, config
end

return M
