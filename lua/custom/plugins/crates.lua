return {
  'saecki/crates.nvim',
  tag = 'stable',
  event = { 'BufRead Cargo.toml' },
  opts = {
    completion = {
      -- Complete crate names from crates.io searches (off by default).
      crates = {
        enabled = true,
      },
    },
    lsp = {
      -- In-process language server: powers completion, code actions and hover
      -- inside Cargo.toml. blink.cmp picks up completions via its existing `lsp`
      -- source, and `grk` (vim.lsp.buf.hover) shows crate info.
      enabled = true,
      actions = true,
      completion = true,
      hover = true,
    },
  },
}
