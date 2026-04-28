return {
    "folke/trouble.nvim",
    opts = {
        auto_open = false,
        auto_close = true,
        use_diagostics_signs = true,
    },
    cmd = "Trouble",
    keys = {
        { "<leader>t", ":Trouble diagnostics toggle<cr>", desc = "Toggle Trouble" },
    },
    lazy = false,
}

