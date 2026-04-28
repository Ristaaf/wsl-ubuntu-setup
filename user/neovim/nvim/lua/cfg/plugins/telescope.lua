return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
    lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"debugloop/telescope-undo.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^2.0.0",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.load_extension("undo")
		telescope.load_extension("fzf")
		-- telescope.load_extension("live_grep_args")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<c-k>"] = actions.move_selection_previous,
						["<c-j>"] = actions.move_selection_next,
					},
				},
				file_ignore_patterns = { "node%_modules/.*", ".git/.*", "dist/.*", "build/.*", "**/*.spec.ts", "cypress/.*" },
				layout_strategy = "vertical",
				hidden = true,
			},
			extensions = {
				undo = {},
				fzf = {},
				live_grep_args = {},
			},
		})

		builtin.lsp_references({
			layout_strategy = "vertical",
			layout_config = {
				width = 1.5,
				preview_cutoff = 81,
			},
		})
	end,
	keys = {
		{
			"<leader>ff",
			":lua require'telescope.builtin'.find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
			"Fuzzy find files by name",
		},
		{ "<leader>fs", ":Telescope live_grep<cr>", "Find text in current working directory" },
		{
			"<leader>fas",
			":lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
			"Find text in current working directory with args",
		},
		{ "<leader>fc", ":Telescope grep_string<cr>", "Find text under cursor in current working directory" },
		{ "<leader>fb", ":Telescope buffers<cr>", "List open buffers" },
		{ "<leader>fh", ":Telescope help_tags<cr>", "List all help tags" },
		{ "<leader>fr", ":Telescope resume<cr>", "Resume telescope" },
		{ "<leader>fg", ":Telescope git_status<cr>", "List all files changed in git" },
		{ "<leader>fd", ":Telescope diagnostics<cr>", "Show diagnostics" },
		{ "<leader>fu", ":Telescope undo<cr>", "Show undo" },
	},
}


