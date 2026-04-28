return {
  'stevearc/aerial.nvim',
  opts = {
    -- Prefer Tree-sitter, fallback to LSP/markdown if needed
    backends = { 'treesitter', 'lsp', 'markdown' },
    layout = { max_width = 40, min_width = 24, default_direction = 'right' },
    highlight_on_jump = 300,
    nerd_font = 'auto',
    -- Filter what you consider “signal” for your languages
    filter_kind = {
      -- Common kinds; tune to your taste
      'Class', 'Struct', 'Interface', 'Trait',
      'Function', 'Method', 'Constructor',
      'Enum', 'Type', 'Module', 'Namespace',
      'Field', 'Property',
    },
  },
  keys = {
    { '<leader>a', '<cmd>AerialToggle!<CR>', desc = 'Toggle Aerial outline' },
    { ']a', function() require('aerial').next() end, desc = 'Next symbol' },
    { '[a', function() require('aerial').prev() end, desc = 'Prev symbol' },
  },
}


