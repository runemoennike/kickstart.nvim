return {
  'equalsraf/neovim-gui-shim',
  lazy = true, -- Only loaded by GUI clients (nvim-qt, neovide) when needed
  cond = function()
    return vim.fn.has 'gui_running' == 1 or vim.g.neovide or vim.g.GuiLoaded
  end,
}
