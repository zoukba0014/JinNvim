vim.g.mapleader = " "

vim.keymap.set("i", "jk", "<ESC>", { desc = "back to the normal mode from insert" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save and formating file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit without Save" })
vim.keymap.set("n", "<leader>v", vim.cmd.Ex, { desc = "back to the preview root" })

-- copy to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy selected item to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy current line to system clipboard" })

-- swich windows
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus on the right windows" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus on the left windows" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus on the down windows" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus on the up windows" })

-- split windows
vim.keymap.set("n", "<C-->", "<cmd>split<CR>", { desc = "Horizontal split windows" })
vim.keymap.set("n", "<C-\\>", "<cmd>vsplit<CR>", { desc = "Vertical split windows" })
