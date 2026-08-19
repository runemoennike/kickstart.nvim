return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  -- The `master` branch is frozen and unsupported on Neovim 0.12+. `main` is the
  -- actively developed rewrite. It requires Neovim 0.12+, `tree-sitter-cli` (0.26.1+),
  -- `curl`/`tar`, and a C compiler on your PATH to install parsers.
  branch = 'main',
  lazy = false, -- the main branch does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'
    ts.setup {}

    -- Parsers to always keep installed (installed asynchronously in the background).
    local ensure = {
      'bash',
      'c',
      'c_sharp',
      'diff',
      'javascript',
      'gitcommit',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'powershell',
      'python',
      'query',
      'rust',
      'toml',
      'vim',
      'vimdoc',
      'yaml',
    }
    local ensured = {}
    for _, lang in ipairs(ensure) do
      ensured[lang] = true
    end

    -- Precompute the set of installable parsers for quick auto-install lookups.
    local available = {}
    for _, lang in ipairs(ts.get_available()) do
      available[lang] = true
    end

    -- Enable treesitter highlighting + (experimental) indentation for a buffer,
    -- if a parser is available. Ruby keeps the legacy vim regex highlighting and
    -- opts out of treesitter indent (mirrors the old `additional_vim_regex_highlighting`
    -- and `indent.disable` settings).
    local function ts_attach(buf)
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft
      if not pcall(vim.treesitter.start, buf, lang) then
        return false
      end
      if ft == 'ruby' then
        vim.bo[buf].syntax = 'on'
      else
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      return true
    end

    -- Attach to any already-open buffers now (warm start: parsers already installed).
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        ts_attach(buf)
      end
    end

    -- Install the ensured parsers; once compiled, re-attach to open buffers
    -- (covers the very first launch, where parsers are still being built).
    ts.install(ensure):await(function()
      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            ts_attach(buf)
          end
        end
      end)
    end)

    -- Turn features on per buffer, and auto-install parsers for other filetypes on
    -- demand (equivalent to the old `auto_install = true`).
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
      callback = function(ev)
        if ts_attach(ev.buf) then
          return
        end
        -- Parser not installed yet. Ensured parsers are handled by the startup
        -- install above; auto-install anything else that has a known parser.
        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
        if not ensured[lang] and available[lang] then
          ts.install({ lang }):await(function(err)
            if err then
              return
            end
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(ev.buf) then
                ts_attach(ev.buf)
              end
            end)
          end)
        end
      end,
    })
  end,
}
