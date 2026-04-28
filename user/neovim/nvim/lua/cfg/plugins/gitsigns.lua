return {
	"lewis6991/gitsigns.nvim",
    event = "BufEnter",
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
	},
	keys = {
		{ "<leader>tlb", ":Gitsigns toggle_current_line_blame<CR>" },
	},
}

