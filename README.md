# Personal Neovim Configuration

Forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Windows-primary (`%LOCALAPPDATA%\nvim`). Requires Neovim stable or nightly.

## Keybindings

See [KEYBINDINGS.md](KEYBINDINGS.md) for a full list of custom keybindings.

## Directory Layout

```
init.lua                       -- entrypoint; all plugins registered here
lua/
  kickstart/plugins/           -- upstream kickstart plugin configs (may be modified)
  custom/plugins/              -- user-added plugin configs
  custom/local/                -- locally developed plugins (loaded via lazy.nvim dir=)
  neovide.lua                  -- loaded conditionally when vim.g.neovide is true
ginit.vim                      -- nvim-qt GUI settings (font, scroll zoom)
```

## External Dependencies

### Required

| Tool | Purpose |
|------|---------|
| [git](https://git-scm.com/) | Plugin management, gitsigns, treesitter parser builds |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Telescope live grep, todo-comments search |
| C compiler (gcc / MSVC cl) | Treesitter parser compilation, telescope-fzf-native |
| [Nerd Font](https://www.nerdfonts.com/) (FiraCode Nerd Font recommended) | Icons throughout the UI |

### Optional (general)

| Tool | Purpose |
|------|---------|
| [fd](https://github.com/sharkdp/fd) | Faster file finding in Telescope, venv-selector |
| make | telescope-fzf-native build (on Windows, CMake can be used instead) |
| [Neovide](https://neovide.dev/) | GUI frontend (config in `lua/neovide.lua`) |
| nvim-qt | GUI frontend (config in `ginit.vim`) |

### Python Development

| Tool | Purpose |
|------|---------|
| pyright | Python LSP (auto-installed by Mason) |
| debugpy | Python debug adapter (auto-installed by Mason) |
| pynvim (`pip install pynvim`) | Required by molten-nvim for Jupyter integration |
| jupyter_client, ipykernel | Molten kernel communication |
| [jupytext](https://github.com/mwouts/jupytext) | Open `.ipynb` notebooks as plain text |

### Elixir Development

| Tool | Purpose |
|------|---------|
| Elixir/Erlang runtime | Required by ElixirLS and mix |
| elixirls | Elixir LSP (auto-installed by Mason) |
| mix | Elixir build tool, used by neotest-elixir |

### C# Development

| Tool | Purpose |
|------|---------|
| [.NET SDK](https://dotnet.microsoft.com/) | Required by Roslyn LSP |
| roslyn | C# LSP (auto-installed by Mason via Crashdummyy registry) |

### Web / TypeScript Development

| Tool | Purpose |
|------|---------|
| [Node.js](https://nodejs.org/) | Required by ts_ls, jsonls, yamlls |
| ts_ls | TypeScript/JavaScript LSP (auto-installed by Mason) |

### Other Language Servers (all Mason-managed)

- `lua_ls` -- Lua
- `powershell_es` -- PowerShell
- `jsonls` -- JSON
- `yamlls` -- YAML
- `azure_pipelines_ls` -- Azure Pipelines YAML
- `tombi` -- TOML

## Plugins

### Core

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI component library |

### Editor

| Plugin | Purpose |
|--------|---------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder (+ fzf-native, ui-select, live-grep-args) |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [harpoon](https://github.com/ThePrimeagen/harpoon) (v2) | Quick file navigation |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Show pending keybinds |
| [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) | Auto-detect indentation |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | ai, surround, statusline, hipatterns |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight TODO/FIXME comments |
| [persistence.nvim](https://github.com/folke/persistence.nvim) | Session management |
| [winbar.nvim](https://github.com/ramilito/winbar.nvim) | Breadcrumb winbar |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git gutter signs |

### LSP & Completion

| Plugin | Purpose |
|--------|---------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP/tool package manager |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Mason + lspconfig bridge |
| [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Auto-install Mason tools |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Autocompletion |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Lua LSP workspace config |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting (stylua for Lua) |
| [roslyn.nvim](https://github.com/seblyng/roslyn.nvim) | C# Roslyn LSP integration |

### Debugging

| Plugin | Purpose |
|--------|---------|
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debug Adapter Protocol client |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | Debugger UI |
| [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python) | Python debugging |
| [mason-nvim-dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim) | Mason + DAP bridge |

### Testing

| Plugin | Purpose |
|--------|---------|
| [neotest](https://github.com/nvim-neotest/neotest) | Test runner framework |
| [neotest-elixir](https://github.com/jfpedroza/neotest-elixir) | Elixir test adapter |

### Jupyter / Notebooks

| Plugin | Purpose |
|--------|---------|
| [molten-nvim](https://github.com/benlubas/molten-nvim) | Jupyter kernel execution in Neovim |
| [jupytext.nvim](https://github.com/GCBallesteros/jupytext.nvim) | Open .ipynb as plain text |
| [NotebookNavigator.nvim](https://github.com/GCBallesteros/NotebookNavigator.nvim) | Notebook cell navigation |

### Treesitter

| Plugin | Purpose |
|--------|---------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting / parsing |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Code-aware text objects |

### Appearance

| Plugin | Purpose |
|--------|---------|
| [gruvbox-material](https://github.com/sainnhe/gruvbox-material) | Colorscheme |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Render markdown in-buffer |

### Local Plugins

| Plugin | Purpose |
|--------|---------|
| `lua/custom/local/dragdrop-nvim` | Drag-and-drop support |

## Formatting

[StyLua](https://github.com/JohnnyMorganz/StyLua) is the Lua formatter. Config is in `.stylua.toml` (160 col width, 2-space indent, single quotes).

Format-on-save is **disabled** for: `c`, `cpp`, `elixir`, `eelixir`, `heex`, `surface`, `ps1`, `psm1`, `psd1`. Use `<leader>f` to format those manually.

Run StyLua manually:

```
stylua .
```

## Treesitter Parsers (auto-installed)

bash, c, c_sharp, diff, javascript, gitcommit, html, lua, luadoc, markdown, markdown_inline, powershell, python, query, toml, vim, vimdoc, yaml

Additional parsers are installed automatically when opening files of other types (`auto_install = true`).

## Verification

There is no test suite. To verify the config works:

- `:Lazy` -- check plugin install status
- `:checkhealth` -- run Neovim health checks
- `:Mason` -- verify LSP servers and tools are installed
- `:ConformInfo` -- check active formatters for current buffer

## Quick Install (Windows)

```powershell
# Clone
git clone <your-repo-url> "$env:LOCALAPPDATA\nvim"

# Install external tools (example using scoop)
scoop install ripgrep fd gcc make stylua

# Install Python tools for Jupyter support (optional)
pip install pynvim jupyter_client ipykernel
uv tool install jupytext
```

Launch Neovim and lazy.nvim will install all plugins automatically. Mason will then install configured LSP servers and tools.
