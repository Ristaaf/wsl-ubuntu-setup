local map = require("cfg/functions/map")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

map("i", "jk", "<esc>", "Back to normal mode")

map("n", "<leader>nh", ":nohl<cr>", "Turn off current search highlighted text")

map("n", "<leader>+", "<c-a>", "Increment number under cursor")
map("n", "<leader>-", "<c-x>", "Decrement number under cursor")

map("n", "<leader>sv", "<c-w>v", "Split window vertically")
map("n", "<leader>sh", "<c-w>s", "Split window horizontally")
map("n", "<leader>sx", ":close<cr>", "Close last window")

map("n", "<leader>w", "<cmd>w<cr>", "Save current buffer")

map("n", "<leader>k", ":bnext<cr>", "Switch to the next buffer")
map("n", "<leader>j", ":bprev<cr>", "Switch to the previous buffer")
map("n", "<leader>bd", ":bp | bd #<cr>", "Close current buffer")

map("n", "<c-a>", "gg<s-v>G", "Select all text in buffer")

map("n", "<a-up>", ":m .-2<cr>==", "Move current line up")
map("n", "<a-down>", ":m .1<cr>==", "Move current line down")
map("v", "<a-up>", ":m '<-2<cr>gv=gv", "Move selected lines down")
map("v", "<a-down>", ":m '>+1<cr>gv=gv", "Move selected lines up")

map("n", "<leader>lw", ":set wrap!<cr>", "Toggle line wrap")
map("n", "gf", ":Telescope lsp_references show_line=false<CR>", "show definition, references")
map("n", "gD", vim.lsp.buf.declaration, "got to declaration")
map("n", "gd", vim.lsp.buf.definition, "see definition and make edits in window")
map("n", "gi", vim.lsp.buf.implementation, "go to implementation")
map("n", "<leader>ca", vim.lsp.buf.code_action, "see available code actions")
map("n", "<leader>rn", vim.lsp.buf.rename, "smart rename")
map("n", "<leader>D", vim.lsp.buf.type_definition, "show  diagnostics for line")
map("n", "<leader>d", vim.diagnostic.open_float, "show diagnostics for cursor")
map("n", "[d", vim.diagnostic.goto_prev, "jump to previous diagnostic in buffer")
map("n", "]d", vim.diagnostic.goto_next, "jump to next diagnostic in buffer")
map("n", "K", vim.lsp.buf.hover, "show documentation for what is under cursor")
map("n", "<leader>o", "<cmd>Outline<CR>", "toggle symbol outline sidebar")
map("n", "<leader>ndh", vim.lsp.buf.clear_references, "clear highlights of current word")
map("n", "<leader>h", vim.lsp.buf.document_highlight, "highlight current word")

map("n", "<a-j>", "<cmd>cnext<CR>", "Go to next item in quickfix list")
map("n", "<a-k>", "<cmd>cprev<CR>", "Go to previous item in quickfix list")
map("n", "<leader>cc", "<cmd>cclose<CR>", "Close quickfix list")
map("n", "<leader>cl", "<cmd>copen<CR>", "Open quickfix list")


