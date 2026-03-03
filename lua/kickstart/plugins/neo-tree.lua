-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = 'Neotree',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  init = function()
    -- Disable netrw so neo-tree can take over
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    -- Auto-open neo-tree when starting with a directory
    if vim.fn.argc() == 1 then
      local arg = vim.fn.argv(0)
      local stat = vim.uv.fs_stat(arg)
      if stat and stat.type == 'directory' then
        -- Delete the directory buffer that Neovim created
        vim.cmd.bdelete()
        -- Change to that directory and open neo-tree
        vim.cmd.cd(arg)
        vim.defer_fn(function()
          require 'neo-tree'
          vim.cmd 'Neotree'
        end, 0)
      end
    end
  end,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
