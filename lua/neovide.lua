-- vim.cmd 'set guifont=Hack\ NF:h10'
-- vim.o.guifont='Consolas:h10'
vim.o.guifont = 'FiraCode Nerd Font:h10'
vim.api.nvim_set_keymap('n', '<F11>', ':let g:neovide_fullscreen = !g:neovide_fullscreen<CR>', {})

vim.keymap.set({ 'n', 'v' }, '<C-+>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>')

vim.keymap.set({ 'n', 'v' }, '<C-ScrollWheelUp>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-ScrollWheelDown>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>')

vim.g.neovide_cursor_animation_length = 0
