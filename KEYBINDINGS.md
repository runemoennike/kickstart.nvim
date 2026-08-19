# Keybindings

Leader key: **Space**

## General

| Mode | Key | Description |
|------|-----|-------------|
| n | `<Esc>` | Clear search highlights |
| n | `<leader>q` | Open diagnostic quickfix list |
| t | `<Esc><Esc>` | Exit terminal mode |
| n | `<C-h>` | Move focus to left window |
| n | `<C-l>` | Move focus to right window |
| n | `<C-j>` | Move focus to lower window |
| n | `<C-k>` | Move focus to upper window |
| n | `<C-S-h>` | Move window left |
| n | `<C-S-l>` | Move window right |
| n | `<C-S-j>` | Move window down |
| n | `<C-S-k>` | Move window up |
| n | `K` | Split line |
| i | `jk` | Exit insert mode |
| n | `Y` | Copy entire line |
| n | `<leader>c` | Open console (PowerShell) |

## Surround (mini.surround)

| Mode | Key | Description |
|------|-----|-------------|
| n | `sa{motion}{char}` | Add surrounding (e.g. `saiw)` surrounds word with parens) |
| n | `sd{char}` | Delete surrounding (e.g. `sd'` removes quotes) |
| n | `sr{old}{new}` | Replace surrounding (e.g. `sr)"` changes parens to quotes) |
| n | `sf{char}` | Find surrounding (move right) |
| n | `sF{char}` | Find surrounding (move left) |
| n | `sh{char}` | Highlight surrounding |
| n | `sn` | Update `n_lines` (number of lines searched) |

## Text Objects (mini.ai)

Enhanced around/inside text objects. Use with any operator (`d`, `c`, `y`, `v`, etc.):

| Key | Description |
|-----|-------------|
| `a)` / `i)` | Around / inside parentheses |
| `a]` / `i]` | Around / inside brackets |
| `a}` / `i}` | Around / inside braces |
| `a'` / `i'` | Around / inside single quotes |
| `a"` / `i"` | Around / inside double quotes |
| `` a` `` / `` i` `` | Around / inside backticks |
| `a>` / `i>` | Around / inside angle brackets |
| `at` / `it` | Around / inside HTML tags |
| `af` / `if` | Around / inside function call |
| `aa` / `ia` | Around / inside argument |

Supports `n` (next) and `l` (last) modifiers, e.g. `cinq` = change inside next quote.

## Completion (blink.cmp, super-tab preset)

| Mode | Key | Description |
|------|-----|-------------|
| i | `<Tab>` | Accept completion / move right in snippet |
| i | `<S-Tab>` | Move left in snippet |
| i | `<C-space>` | Open completion menu / show docs |
| i | `<C-n>` / `<Down>` | Select next item |
| i | `<C-p>` / `<Up>` | Select previous item |
| i | `<C-e>` | Hide menu |
| i | `<C-k>` | Toggle signature help |

## Search (Telescope)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>sh` | Search help |
| n | `<leader>sk` | Search keymaps |
| n | `<leader>sf` | Search files |
| n | `<leader>ss` | Search select (Telescope builtin) |
| n | `<leader>sw` | Search current word |
| n | `<leader>sg` | Search by grep (live grep args) |
| n | `<leader>sG` | Grep current word |
| n | `<leader>sd` | Search diagnostics |
| n | `<leader>sr` | Search resume |
| n | `<leader>s.` | Search recent files |
| n | `<leader><leader>` | Find open buffers |
| n | `<leader>sc` | Search colorschemes |
| n | `<leader>/` | Fuzzy search in current buffer |
| n | `<leader>s/` | Search in open files |
| n | `<leader>sn` | Search Neovim config files |

Inside live grep args picker (insert mode):

| Key | Description |
|-----|-------------|
| `<C-k>` | Quote prompt |
| `<C-i>` | Quote prompt + `--iglob` |
| `<C-space>` | Fuzzy refine |

## LSP (buffer-local, active on LspAttach)

| Mode | Key | Description |
|------|-----|-------------|
| n | `grn` | Rename symbol |
| n, x | `gra` | Code action |
| n | `grr` | Go to references |
| n | `gri` | Go to implementation |
| n | `grd` | Go to definition |
| n | `grD` | Go to declaration |
| n | `gd` | Document symbols |
| n | `gW` | Workspace symbols |
| n | `gs` | Search symbols (treesitter) |
| n | `grt` | Go to type definition |
| n | `grk` | Show symbol info (hover) |

## Rust (rustaceanvim, buffer-local in Rust files)

These override/extend the LSP defaults and are active only in Rust buffers.

| Mode | Key | Description |
|------|-----|-------------|
| n | `grk` | Hover actions (run twice to enter popup, then `<CR>` on an action) |
| n | `grs` | Structural search & replace |
| n | `gme` | Expand macro (recursively) |
| n, x | `gJ` | Join lines (syntax-aware) |

Debugging (`<leader>d*`) and testing (`<leader>r*`) also work in Rust via `codelldb`
and the rustaceanvim neotest adapter. In `Cargo.toml`, `gra` (code action) and `grk`
(hover) are powered by crates.nvim's in-process LSP.

## Formatting

| Mode | Key | Description |
|------|-----|-------------|
| all | `<leader>f` | Format buffer |

## Git

| Mode | Key | Description |
|------|-----|-------------|
| n | `]c` | Next git change |
| n | `[c` | Previous git change |
| n | `<leader>gs` | Stage hunk |
| v | `<leader>gs` | Stage hunk (visual) |
| n | `<leader>gr` | Reset hunk |
| v | `<leader>gr` | Reset hunk (visual) |
| n | `<leader>gS` | Stage buffer |
| n | `<leader>gu` | Undo stage hunk |
| n | `<leader>gR` | Reset buffer |
| n | `<leader>gp` | Preview hunk |
| n | `<leader>gb` | Blame line |
| n | `<leader>gd` | Diff against index |
| n | `<leader>gD` | Diff against last commit |
| n | `<leader>tb` | Toggle blame line |
| n | `<leader>tD` | Toggle show deleted (inline) |

## Debug (DAP)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>ds` | Start / Continue |
| n | `<leader>di` | Step into |
| n | `<leader>do` | Step over |
| n | `<leader>dO` | Step out |
| n | `<leader>db` | Toggle breakpoint |
| n | `<leader>dB` | Conditional breakpoint |
| n | `<leader>du` | Toggle debug UI |
| n, v | `<leader>de` | Evaluate expression |
| n | `<leader>dr` | Open REPL |
| n | `<leader>dt` | Terminate |

## Harpoon

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>H` | Add file to Harpoon |
| n | `<leader>h` | Harpoon quick menu |
| n | `<leader>1` -- `<leader>9` | Jump to Harpoon file 1--9 |

## Testing (Neotest)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>rr` | Run last test(s) |
| n | `<leader>rn` | Run nearest test |
| n | `<leader>rf` | Run tests in current file |
| n | `<leader>rs` | Stop running tests |
| n | `<leader>rc` | Clear test panel |
| n | `<C-w>t` | View test window |
| n | `<leader>tt` | Toggle test panel |

## Jupyter / Notebooks

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>ji` | Init kernel |
| n | `<leader>jo` | Show output |
| n | `<leader>jh` | Hide output |
| n | `<leader>jd` | Delete cell |
| n | `<leader>jx` | Execute cell |
| n | `<leader>jr` | Run cell and move to next |
| n | `]h` | Next cell |
| n | `[h` | Previous cell |

## File Explorer (Neo-tree)

| Mode | Key | Description |
|------|-----|-------------|
| n | `\` | Reveal / toggle Neo-tree |

## Sessions (Persistence)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>zs` | Restore session |
| n | `<leader>zS` | Select session |
| n | `<leader>zl` | Restore last session |
| n | `<leader>zd` | Don't save current session |

## Python

| Mode | Key | Description |
|------|-----|-------------|
| n | `<leader>a` | Activate Python venv |

## Bufferline

| Mode | Key | Description |
|------|-----|-------------|
| n | `<A-,>` | Previous buffer |
| n | `<A-.>` | Next buffer |
| n | `<A-n>` | New buffer |
| n | `<A-t>` | Pin/unpin buffer |
| n | `<A-p>` | Jump to tab |

## Treesitter Text Objects & Motions

### Text objects (visual / operator-pending)

| Key | Description |
|-----|-------------|
| `am` | Around method/function |
| `im` | Inside method/function |
| `ac` | Around class |
| `ic` | Inside class |
| `as` | Around scope |

### Motions (normal / visual / operator-pending)

| Key | Description |
|-----|-------------|
| `]m` | Next method/function start |
| `]]` | Next class start |
| `]o` | Next loop start |
| `]s` | Next scope start |
| `]z` | Next fold |
| `]M` | Next method/function end |
| `][` | Next class end |
| `[m` | Previous method/function start |
| `[[` | Previous class start |
| `[M` | Previous method/function end |
| `[]` | Previous class end |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |

### Repeatable motions

| Key | Description |
|-----|-------------|
| `;` | Repeat last move (next) |
| `,` | Repeat last move (previous) |

## Neovide GUI (only when running in Neovide)

| Mode | Key | Description |
|------|-----|-------------|
| n | `<F11>` | Toggle fullscreen |
| n, v | `<C-+>` | Zoom in |
| n, v | `<C-->` | Zoom out |
| n, v | `<C-0>` | Reset zoom |
| n, v | `<C-ScrollWheelUp>` | Zoom in (scroll) |
| n, v | `<C-ScrollWheelDown>` | Zoom out (scroll) |
