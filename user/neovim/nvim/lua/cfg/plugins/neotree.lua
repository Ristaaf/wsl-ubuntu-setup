return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		sources = { "filesystem", "buffers", "git_status", "document_symbols" },
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = false,
      async_directory_scan = "always",
      git_status_async = true,
      git_status_async_options = {
        batch_size = 1000,
        batch_delay= 10,
        max_lines = 10000,
      }
		},
		window = {
			width = 60,
			mappings = {
				["<space>"] = "none",
			},
		},
		default_component_configs = {},
		close_if_last_window = true,
		event_handlers = {
			{
				event = "file_opened",
				handler = function(file_path)
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
		},
	},
	keys = {
		{ "<leader>e", ":Neotree filesystem reveal left toggle=true<cr>", "Toggle filetree" },
	},
}



