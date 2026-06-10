return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			-- The nvim-treesitter `main` branch compiles parsers with the
			-- `tree-sitter` CLI. Volta intercepts the shim inside Node projects
			-- and fails, so prefer the Volta-free binary in ~/.local/bin.
			vim.env.PATH = vim.fn.expand("~/.local/bin") .. ":" .. vim.env.PATH

			local ts = require("nvim-treesitter")

			ts.setup()

			local ensure_installed = {
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
				"tsx",
			}

			ts.install(ensure_installed)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("cfg_treesitter", { clear = true }),
				callback = function(args)
					local buf = args.buf
					local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
					if not lang then
						return
					end
					-- Only start when a parser for this language is available.
					-- `language.add` returns false (without erroring) when the
					-- parser is missing, so check the return value, not pcall.
					local ok, has_parser = pcall(vim.treesitter.language.add, lang)
					if not ok or not has_parser then
						return
					end
					vim.treesitter.start(buf)
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
	},
}

