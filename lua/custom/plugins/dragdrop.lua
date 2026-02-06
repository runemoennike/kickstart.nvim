return {
  name = 'dragdrop.nvim',
  dir = vim.fs.normalize(vim.fn.stdpath 'config' .. '/lua/custom/local/dragdrop-nvim'),
  lazy = false,

  config = function()
    require('custom.local.dragdrop-nvim').setup()
  end,
}
