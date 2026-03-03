# AGENTS.md - Neovim Configuration

This is a Neovim configuration based on kickstart.nvim. It uses Lua for configuration
and lazy.nvim for plugin management.

## Quick Reference

| Task | Command |
|------|---------|
| Check health | `:checkhealth` or `:checkhealth kickstart` |
| Plugin status | `:Lazy` |
| Update plugins | `:Lazy update` |
| Install LSP tools | `:Mason` |
| Format buffer | `<leader>f` |
| Run StyLua check | `stylua --check .` |

## Build/Lint/Test Commands

### Formatting (StyLua)

```bash
# Check formatting
stylua --check .

# Format all files
stylua .

# Format specific file
stylua lua/custom/plugins/example.lua
```

Configuration is in `.stylua.toml`. CI runs `stylua --check .` on PRs.

### Running Tests (via neotest)

This config uses neotest for running tests within Neovim:

| Keybinding | Action |
|------------|--------|
| `<leader>rn` | Run nearest test |
| `<leader>rf` | Run tests in current file |
| `<leader>rr` | Re-run last test(s) |
| `<leader>rs` | Stop running tests |
| `<leader>rc` | Clear test panel |
| `<leader>tt` | Toggle test panel |
| `<C-w>t` | View test output window |

### Health Checks

```vim
:checkhealth kickstart
```

Verifies: Neovim version, git, make, unzip, ripgrep (rg).

## Code Style Guidelines

### File Naming

- Use lowercase with underscores: `todo_comments.lua`, `guess_indent.lua`
- Plugin configs go in `lua/kickstart/plugins/` (core) or `lua/custom/plugins/` (custom)
- Local plugins go in `lua/custom/local/<plugin-name>/init.lua`

### StyLua Configuration

```toml
column_width = 160
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferSingle"
call_parentheses = "None"
```

### Imports and Requires

```lua
-- Require at top of config functions, not file level (for lazy loading)
config = function()
  local telescope = require 'telescope'
  local builtin = require 'telescope.builtin'
  -- ...
end

-- Use pcall for optional extensions
pcall(telescope.load_extension, 'fzf')
```

### Plugin Specification Pattern

```lua
return {
  'author/plugin-name',
  event = 'VeryLazy',              -- Lazy loading trigger
  dependencies = { 'dep/plugin' }, -- Required plugins
  opts = {                         -- Passed to plugin.setup()
    option = 'value',
  },
  config = function()              -- Custom setup logic
    require('plugin').setup {}
  end,
  keys = {                         -- Keybindings (also triggers lazy load)
    { '<leader>x', '<cmd>Command<cr>', desc = 'Description' },
  },
}
```

### Keybinding Conventions

- Leader key: Space (`<leader>`)
- Use bracket notation in descriptions: `'[S]earch [F]iles'`
- Prefix groupings:
  - `<leader>s` - Search operations
  - `<leader>g` - Git operations
  - `<leader>t` - Toggle operations
  - `<leader>r` - Run operations (tests)
  - `gr` - LSP goto references

```lua
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
```

### Section Comments

```lua
-- [[ Basic Keymaps ]]
-- [[ Configure Plugins ]]
```

### Type Annotations (EmmyLua)

```lua
---@class LspServersConfig
---@field mason table<string, vim.lsp.Config>

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
```

### Error Handling

```lua
-- Use pcall for operations that may fail
local ok, result = pcall(require, 'optional-module')
if ok then
  result.setup {}
end
```

## Directory Structure

```
nvim/
├── init.lua                    # Main entry point
├── .stylua.toml                # Formatter config
├── ginit.vim                   # GUI-specific config (nvim-qt, neovide)
├── lua/
│   ├── kickstart/
│   │   ├── health.lua          # :checkhealth module
│   │   └── plugins/            # Core plugin configs
│   └── custom/
│       ├── plugins/            # Custom plugin configs
│       └── local/              # Local plugins (in-repo development)
└── doc/                        # Vim help files
```

## LSP Configuration

LSP servers are configured in `lua/kickstart/plugins/lspconfig.lua`:

- `servers.mason` - Servers installed via Mason (lua_ls, pyright, ts_ls, etc.)
- `servers.others` - System-installed servers (roslyn, elixirls, etc.)

## Plugin Management

Plugins are managed by lazy.nvim. Each file in `lua/*/plugins/*.lua` returns a
plugin spec table that is automatically loaded.

To add a plugin:
1. Create a new file in `lua/custom/plugins/your_plugin.lua`
2. Return the plugin spec table
3. Restart Neovim or run `:Lazy`

To disable a plugin:
- Comment out the require line in `init.lua`, or
- Add `enabled = false` to the plugin spec

## Performance Tips

- Use lazy loading: `event`, `cmd`, `keys`, `ft` in plugin specs
- Avoid `require()` at file top-level; use inside `config` functions
- Check startup time: `nvim --startuptime startup.log`
- Profile plugins: `:Lazy profile`

## Common Issues

- **Missing tools**: Run `:Mason` to install LSP servers and formatters
- **Plugin errors**: Run `:Lazy` and check for updates or conflicts
- **Slow startup**: Check `:Lazy profile` for slow plugins
