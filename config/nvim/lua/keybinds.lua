local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Remap space as leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- saving
keymap('n', '<c-s>', ':q<CR>', {})
keymap('i', '<c-s>', '<Esc>:w<CR>a', {})

-- navigate windows
keymap('n', '<c-j>', '<c-w>j', opts)
keymap('n', '<c-h>', '<c-w>h', opts)
keymap('n', '<c-k>', '<c-w>k', opts)
keymap('n', '<c-l>', '<c-w>l', opts)

-- noremap space
keymap('n', '<space>', '', opts)

-- smooth scrolling (not working)
-- keymap('n', '<ScrollWheelUp>', '<C-u>', opts)
-- keymap('n', '<ScrollWheelDown>', '<C-d>', opts)

-- telescope searching
-- keymap('n', '<Leader>ff', ':Telescope find_files<CR>', opts)
-- keymap('n', '<Leader>fr', ':Telescope find_files<CR>', opts)

-- terminal keymaps
function _G.set_terminal_keymaps()
    local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')


-- better indenting
keymap('v', '<', '<gv', { noremap = true, silent = true})
keymap('v', '>', '>gv', { noremap = true, silent = true})

-- navigate buffers 
keymap('n', '<A-l>', "<cmd>bnext<cr>", opts)
keymap('n', '<A-h>', "<cmd>bprevious<cr>", opts)

-- remove buffer 
keymap('n', '<A-q>', '<cmd>bd<cr>', opts)
