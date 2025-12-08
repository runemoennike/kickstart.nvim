return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'jfpedroza/neotest-elixir',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-elixir',
      },
    }
  end,
  keys = {
    {
      '<leader>rr',
      function()
        require('neotest').run.run_last()
      end,
      desc = '[R]un last test(s).',
    },
    {
      '<leader>rn',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run [n]earest test.',
    },
    {
      '<leader>rf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run tests in current [f]ile.',
    },
    {
      '<leader>rs',
      function()
        require('neotest').run.stop()
      end,
      desc = '[S]top running tests.',
    },
    {
      '<leader>vt',
      function()
        require('neotest').output.open { enter = true }
      end,
      desc = 'View [t]est window.',
    },
    {
      '<leader>vT',
      function()
        require('neotest').output_panel.open()
      end,
      desc = 'View [t]est panel.',
    },
  },
}
