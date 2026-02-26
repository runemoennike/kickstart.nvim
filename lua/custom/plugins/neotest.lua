return {
  'nvim-neotest/neotest',
  event = 'VeryLazy',
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
        require('neotest').output_panel.clear()
        require('neotest').run.run_last()
      end,
      desc = '[R]un last test(s).',
    },
    {
      '<leader>rn',
      function()
        require('neotest').output_panel.clear()
        require('neotest').run.run()
      end,
      desc = 'Run [n]earest test.',
    },
    {
      '<leader>rf',
      function()
        require('neotest').output_panel.clear()
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
      '<leader>rc',
      function()
        require('neotest').output_panel.clear()
      end,
      desc = '[C]lear test panel.',
    },
    {
      '<C-w>t',
      function()
        require('neotest').output.open { enter = true }
      end,
      desc = 'View [t]est window.',
    },
    {
      '<leader>tt',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle [t]est panel.',
    },
  },
}
