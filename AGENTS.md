# AGENTS.md

Personal Neovim config forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Windows-primary (`%LOCALAPPDATA%\nvim`). Requires Neovim stable/nightly.

## Directory layout

```
init.lua                       -- entrypoint; all plugins registered here via require()
lua/
  kickstart/plugins/           -- upstream kickstart plugin configs (may be modified)
  custom/plugins/              -- user-added plugin configs
  custom/local/                -- locally developed plugins (loaded via lazy.nvim `dir =`)
  neovide.lua                  -- loaded conditionally when vim.g.neovide is true
ginit.vim                      -- nvim-qt GUI settings (font, scroll zoom)
```

- **New plugins** go in `lua/custom/plugins/<name>.lua` and must be added as `require 'custom.plugins.<name>'` in the `lazy.setup()` call in `init.lua` (line ~183).
- **Kickstart plugins** live in `lua/kickstart/plugins/`. Same pattern: each file returns a lazy.nvim plugin spec, referenced from `init.lua`.
- Some plugins are commented out in `init.lua` (bufferline, dashboard, autopairs, lint). Check before assuming they are active.

## Formatting

- **StyLua** is the only Lua formatter. CI enforces it on PRs.
- Config (`.stylua.toml`): 160 column width, 2-space indent, single quotes preferred, no call parentheses.
- `conform.nvim` runs StyLua on save for Lua files.
- **Format-on-save is disabled** for: `c`, `cpp`, `elixir`, `eelixir`, `heex`, `surface`, `ps1`, `psm1`, `psd1`. These filetypes must be formatted manually with `<leader>f`.

Run StyLua manually from repo root:

```
stylua .
```

## LSP configuration

LSP servers are configured in `lua/kickstart/plugins/lspconfig.lua` inside a `servers` table with two sub-tables:

- `servers.mason` -- servers installed and managed by Mason (auto-installed on startup).
- `servers.others` -- servers managed outside Mason (manually installed on the system).

Both use the same structure: `server_name = { <lsp config> }`. Mason also auto-installs tools listed in the `ensure_installed` array (currently includes `stylua`).

Notable servers: `lua_ls`, `pyright`, `roslyn` (C# -- also has a separate plugin `seblyng/roslyn.nvim`), `elixirls` (has a custom diagnostic debounce handler to prevent premature clearing), `ts_ls`, `powershell_es`, `jsonls`, `yamlls`, `azure_pipelines_ls`, `tombi`.

## Local plugins

Locally developed plugins live under `lua/custom/local/<plugin-name>/`. They are loaded by lazy.nvim using `dir =` pointing to `vim.fn.stdpath('config') .. '/lua/custom/local/<plugin-name>'`. See `lua/custom/plugins/dragdrop.lua` for the pattern.

## GUI

- **Neovide**: `lua/neovide.lua` is loaded when `vim.g.neovide == true` (checked at end of `init.lua`). Sets FiraCode Nerd Font, zoom keymaps, disables cursor animation.
- **nvim-qt**: `ginit.vim` handles font and GUI element configuration.
- `vim.g.have_nerd_font = true` is set in `init.lua`; icon-dependent plugins rely on this.

## Verification

There is no test suite or build step. To verify the config works:

- `:Lazy` -- check plugin install status
- `:checkhealth` -- run Neovim health checks (including the custom `kickstart.health` module)
- `:Mason` -- verify LSP servers and tools are installed
- `:ConformInfo` -- check active formatters for current buffer
