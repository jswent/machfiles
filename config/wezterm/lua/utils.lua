local M = {}

function M.deep_extend(behavior, ...)
	-- Type definition for behavior
	local valid_behaviors = {
		force = true,
		keep = true,
		error = true,
	}

	-- Ensure behavior is valid
	if not valid_behaviors[behavior] then
		error("Invalid behavior: " .. tostring(behavior) .. ". Expected 'force', 'keep', or 'error'.")
	end

	local result = {}
	local tables = { ... }

	for _, t in ipairs(tables) do
		for k, v in pairs(t) do
			if type(v) == "table" and type(result[k]) == "table" then
				result[k] = M.deep_extend(behavior, result[k], v)
			elseif behavior == "force" or result[k] == nil then
				result[k] = v
			elseif behavior == "keep" then
				result[k] = result[k]
			elseif behavior == "error" then
				error("Conflict at key: " .. k)
			end
		end
	end

	return result
end

return M
