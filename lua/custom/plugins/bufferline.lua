return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  config = function()
    vim.opt.termguicolors = true

    local bufferline = require 'bufferline'
    bufferline.setup {
      options = {
        style_preset = {
          --bufferline.style_preset.minimal,
          bufferline.style_preset.no_italic,
          bufferline.style_preset.no_bold,
        },
        indicator = {
          style = 'none',
        },
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
      },
    }

    vim.keymap.set('n', '<A-,>', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer', silent = true })
    vim.keymap.set('n', '<A-.>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer', silent = true })
    vim.keymap.set('n', '<A-n>', ':enew<CR>', { desc = 'New buffer', silent = true })
    vim.keymap.set('n', '<A-t>', ':BufferLineTogglePin<CR>', { desc = 'Pin/unpin buffer', silent = true })
    vim.keymap.set('n', '<A-p>', ':BufferLinePick<CR>', { desc = 'Jump to tab', silent = true })
  end,
  version = '*',
}
