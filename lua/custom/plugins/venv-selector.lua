return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
  },
  ft = 'python', -- Load when opening Python files
  keys = {
    { '<leader>a', '<cmd>VenvSelect<cr>', desc = '[A]ctivate Python venv' }, -- Open picker on keymap
  },
  opts = { -- this can be an empty lua table - just showing below for clarity.
    options = {
      notify_user_on_venv_activation = true,
      search_timeout = 15,
      -- shell = {
      --   shell = 'cmd',
      --   shellcmdflag = '/C ',
      -- },
    },
  },
}
