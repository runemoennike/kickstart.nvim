return {
  'seblyng/roslyn.nvim',
  ft = { 'cs', 'razor' },
  init = function()
    vim.filetype.add {
      extension = {
        razor = 'razor',
        cshtml = 'razor',
      },
    }
  end,
  opts = {
    filewatching = 'roslyn',
  },
}
