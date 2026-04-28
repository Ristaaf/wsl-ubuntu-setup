local function map(mode, lhs, rhs, description)
	vim.keymap.set(mode, lhs, rhs, {noremap = true, silent = true, desc = description});
end

return map;
