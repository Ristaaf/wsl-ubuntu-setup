local opt = vim.opt

opt.shell = "/usr/bin/zsh"
opt.backspace = "indent,eol,start"
opt.cursorline = true
opt.expandtab = true
opt.ignorecase = true
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 2
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.wrap = false
opt.linebreak = true

opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.fillchars = {
    foldopen = "",    -- Icon for open fold
    foldclose = "",   -- Icon for closed fold
    fold = " ",        -- Fill character for folds
    foldsep = " ",     -- Fill character for fold separators
    diff = "/",        -- Fill character for diff mode
    eob = " ",         -- Fill character for end-of-buffer
}

opt.colorcolumn = "120"
vim.g.have_nerd_font = true
opt.clipboard:append("unnamedplus")

vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
    	["+"] = "win32yank.exe -i --crlf",
	["*"] = "win32yank.exe -i --crlf"
    },
    paste = {
    	["+"] = "win32yank.exe -o --lf",
	["*"] = "win32yank.exe -o --lf"
    },
    cache_enabled = 0,
}

opt.laststatus = 3
