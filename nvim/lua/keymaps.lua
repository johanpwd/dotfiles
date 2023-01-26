-- leader key, plain ol' space
vim.g.mapleader = " "

-- make buffer windows easier to navigate
vim.keymap.set("", "<C-h>", "<C-w>h")
vim.keymap.set("", "<C-j>", "<C-w>j")
vim.keymap.set("", "<C-k>", "<C-w>k")
vim.keymap.set("", "<C-l>", "<C-w>l")

-- ctrl-n and ctrl-p for next and previous buffers, but only in normal mode
vim.keymap.set("n", "<C-n>", ":bn<cr>", { silent = true })
vim.keymap.set("n", "<C-p>", ":bp<cr>", { silent = true })

-- make < and > shifts retain selection
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Will make the cursor say in place when doing J
vim.keymap.set("n", "J", "mzJ`z", { noremap = true, silent = true })

-- J and K moves selected text down/up. keeps selection and autoformats
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { noremap = true, silent = true })

-- Copy and paste to global clipboard
vim.keymap.set("v", "<leader>cc", '"*y', { noremap = true })
vim.keymap.set("n", "<leader>cp", '"*P', { noremap = true })

-- When pasting over a visual selection don't yank the selection
vim.keymap.set("v", "p", '"_dP', { silent = true })

-- Keep the cursor centered when searching (if possible)
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

-- Center the screen when going up or down
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

-- Open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Sane pasting
vim.keymap.set("x", "<leader>p", "\"_dP")

-- I tend to mistype these
vim.cmd([[
  cabbr W w
  cabbr Q q
  cabbr Wq wq
]])
