return {
    "numToStr/Comment.nvim",
    opts = {
        -- Neovim 0.11+ changed `vim.treesitter.get_parser` to return nil
        -- (instead of erroring) when a buffer has no parser. Comment.nvim's
        -- treesitter-based commentstring calculation then indexes that nil and
        -- throws a raw error surfaced as "[Comment.nvim] nil". Returning the
        -- buffer's native 'commentstring' here short-circuits that code path.
        pre_hook = function()
            return vim.bo.commentstring
        end,
    },
    lazy = false,
}


