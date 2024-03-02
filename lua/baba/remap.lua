vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex)

-- :m Move line to address.
-- '> The last line of selected range.
-- <CR> --> new line
-- gv Select the previous selected range.
-- = Align the indentations of the selected range.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader>sa", "ggVG")

-- Set current line to center
vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")

-- Clear highlight on pressing <ESC> in normal mode
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")
