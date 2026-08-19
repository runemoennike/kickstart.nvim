return {
  'mrcjkb/rustaceanvim',
  version = '^9',
  lazy = false, -- rustaceanvim lazy-loads itself by filetype; see :h rustaceanvim
  init = function()
    vim.g.rustaceanvim = {
      -- LSP (rust-analyzer) configuration.
      server = {
        -- Buffer-local keymaps, set when rust-analyzer attaches to a buffer.
        -- These run *after* kickstart's LspAttach autocmd, so the `grk` override wins.
        on_attach = function(_, bufnr)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
          end

          -- Override the plain LSP hover (grk) with rustaceanvim's hover actions.
          -- Invoke it twice to jump into the popup, then <CR> on an action.
          map('n', 'grk', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, 'Rust Hover Actions')

          -- Structural search & replace, e.g. :RustLsp ssr "foo($a) ==>> bar($a)"
          map('n', 'grs', function()
            vim.cmd.RustLsp 'ssr'
          end, 'Rust Structural Search Replace')

          -- Expand the macro under the cursor into a scratch buffer.
          map('n', 'gme', function()
            vim.cmd.RustLsp 'expandMacro'
          end, 'Rust Expand Macro')

          -- Syntax-aware join lines (normal + visual).
          map({ 'n', 'x' }, 'gJ', function()
            vim.cmd.RustLsp 'joinLines'
          end, 'Rust Join Lines')
        end,
        default_settings = {
          ['rust-analyzer'] = {
            -- Run clippy instead of `cargo check` on save for richer lints.
            checkOnSave = true,
            check = {
              command = 'clippy',
            },
          },
        },
      },
      -- DAP: rustaceanvim auto-detects the Mason-installed `codelldb`
      -- (see kickstart/plugins/debug.lua), so no explicit adapter config is needed.
    }
  end,
}
