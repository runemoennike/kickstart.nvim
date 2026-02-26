return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope', -- allows :Telescope to load it
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    'nvim-telescope/telescope-live-grep-args.nvim',
  },
  keys = {
    {
      '<leader>sh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        require('telescope.builtin').keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>ss',
      function()
        require('telescope.builtin').builtin()
      end,
      desc = '[S]earch [S]elect Telescope',
    },
    {
      '<leader>sw',
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = '[S]earch current [W]ord',
    },

    -- live_grep with args
    {
      '<leader>sg',
      function()
        require('telescope').extensions.live_grep_args.live_grep_args()
      end,
      desc = '[S]earch by [G]rep',
    },

    {
      '<leader>sG',
      function()
        require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()
      end,
      desc = '[S]earch current word by [G]rep',
    },

    {
      '<leader>sd',
      function()
        require('telescope.builtin').diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        require('telescope.builtin').resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        require('telescope.builtin').oldfiles()
      end,
      desc = '[S]earch recent files',
    },
    {
      '<leader><leader>',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Find buffers',
    },
    {
      '<leader>sc',
      function()
        require('telescope.builtin').colorscheme()
      end,
      desc = '[S]earch [C]olorschemes',
    },

    -- current buffer fuzzy
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
      end,
      desc = '[/] search in buffer',
    },

    -- grep in open files
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end,
      desc = '[S]earch [/] in open files',
    },

    -- search Neovim config
    {
      '<leader>sn',
      function()
        require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
  },

  config = function()
    local telescope = require 'telescope'
    local lga_actions = require 'telescope-live-grep-args.actions'

    telescope.setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        live_grep_args = {
          auto_quoting = false,
          mappings = {
            i = {
              ['<C-k>'] = lga_actions.quote_prompt(),
              ['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob ' },
              ['<C-space>'] = lga_actions.to_fuzzy_refine,
            },
          },
        },
      },
    }

    -- Load extensions if available
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'live_grep_args')
  end,
}
