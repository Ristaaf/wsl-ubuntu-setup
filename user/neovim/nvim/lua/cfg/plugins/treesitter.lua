return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter")

			configs.setup({
				ensure_installed = {
					"bash",
					"lua",
					"css",
					"vimdoc",
					"javascript",
					"html",
					"json",
					"markdown",
					"scss",
					"typescript",
					"rust",
					"toml",
					"angular",
					"yaml",
					"go",
					"python",
          "tsx"
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
	},
}

