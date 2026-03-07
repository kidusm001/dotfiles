-- Global Terminal Navigation
-- Enables seamless Ctrl+hjkl navigation in/out of any terminal buffer

-- Set global terminal keymaps that apply to all terminal buffers
vim.cmd 'tnoremap <C-h> <C-\\><C-n><C-w>h'
vim.cmd 'tnoremap <C-j> <C-\\><C-n><C-w>j'
vim.cmd 'tnoremap <C-k> <C-\\><C-n><C-w>k'
vim.cmd 'tnoremap <C-l> <C-\\><C-n><C-w>l'
vim.cmd 'tnoremap <Esc> <C-\\><C-n>'
vim.cmd 'tnoremap <C-[> <C-\\><C-n>'
