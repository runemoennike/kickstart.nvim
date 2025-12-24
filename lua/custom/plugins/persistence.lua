return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>zs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>zS", function() require("persistence").select() end,desc = "Select Session" },
    { "<leader>zl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>zd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  },
}
