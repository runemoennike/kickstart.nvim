return {
  -- {
  --   'Tsuzat/NeoSolarized.nvim',
  --   lazy = false,
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     local ns = require 'NeoSolarized'
  --     ns.setup {
  --       transparent = false,
  --       style = 'light',
  --     }
  --     -- vim.cmd [[ colorscheme NeoSolarized ]]
  --   end,
  -- },
  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   config = function()
  --     -- vim.cmd 'colorscheme rose-pine'
  --   end,
  -- },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = 'medium' -- soft, medium, hard
      vim.g.gruvbox_material_foreground = 'material' -- material, original, mix
      vim.o.background = 'dark' -- dark, light

      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
}
