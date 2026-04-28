return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            theme = "catppuccin-mocha",
            section_separators = { left = '\u{e0b4}', right = '\u{e0b6}' },
            component_separators = { left = '\u{e0b5}', right = '\u{e0b7}' },
        },
        tabline = {
            lualine_a = { { "buffers", symbols = { alternate_file = "" } } },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "tabs" },
        },
    },
    lazy = false,
}
