-- no recursive map
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = ' '

keymap("", "<leader>w", ":w<CR>", opts)
keymap("", "<leader>q", ":q<CR>", opts)

-- Window navigation
keymap("", "<C-l>", "<C-w>l", opts)
keymap("", "<C-h>", "<C-w>h", opts)
keymap("", "<C-j>", "<C-w>j", opts)
keymap("", "<C-k>", "<C-w>k", opts)

-- Enter normal mode by pressing jk
keymap("i", "jk", "<ESC>", opts)

-- keep search results in the center of screen
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)

-- cancel highlight
keymap("n", "<leader>l", ":nohl<CR>", opts)

-- preserve highlight after indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- close quickfix list
keymap("n", "<leader>cl", "<CMD>ccl<CR>", opts);

keymap("n", "<leader>b", "<CMD>GitBlame<CR>", opts)

keymap("n", "<leader>md", "<CMD>m +1<CR>", opts)

vim.keymap.set('n', '<leader>cc', function()
  local file = vim.fn.expand('%:.')
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  vim.fn.setreg('+', file .. ':' .. line .. ':' .. col)
  vim.notify('Copied ' .. file .. ':' .. line .. ' to clipboard')
end, { desc = 'Copy file:line for Claude Code' })
