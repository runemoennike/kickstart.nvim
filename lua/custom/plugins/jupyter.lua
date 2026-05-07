-- Python dependencies (run once):
--   uv pip install --system --break-system-packages pynvim jupyter_client nbformat ipykernel
--   uv tool install jupytext
--   uv run python -m ipykernel install --user
--
-- After first install, open Neovim and run:
--   :UpdateRemotePlugins
-- then restart Neovim.

return {
  -- jupytext.nvim: transparently open .ipynb files as plain text scripts
  {
    'GCBallesteros/jupytext.nvim',
    lazy = false, -- must load early to intercept .ipynb BufReadCmd
    config = function()
      require('jupytext').setup {
        style = 'percent', -- use # %% cell markers
        output_extension = 'auto', -- .py for python notebooks, etc.
        force_ft = nil, -- auto-detect filetype
      }

      -- Windows workaround: Pyright's file watcher locks .ipynb files on disk,
      -- causing jupytext's os.replace() to fail with PermissionError.
      -- We detect failed saves (leftover tmp files) and retry after stopping Pyright.
      -- This only interrupts Pyright when a lock actually blocks the save.
      if vim.fn.has 'win32' == 1 then
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'python',
          group = vim.api.nvim_create_augroup('jupyter-pyright-save-fix', { clear = true }),
          callback = function(args)
            local bufname = vim.api.nvim_buf_get_name(args.buf)
            if not bufname:match '%.ipynb$' then
              return
            end
            -- Guard against double-wrapping on repeated FileType events
            if vim.b[args.buf]._jupyter_save_wrapped then
              return
            end
            vim.b[args.buf]._jupyter_save_wrapped = true

            -- jupytext registers BufWriteCmd (init.lua:114) before setting filetype
            -- (init.lua:150), so the autocmd exists by the time our FileType fires.
            local autocmds = vim.api.nvim_get_autocmds {
              event = 'BufWriteCmd',
              buffer = args.buf,
              group = 'jupytext-nvim',
            }
            if #autocmds == 0 or not autocmds[1].callback then
              return
            end

            local original_write = autocmds[1].callback
            vim.api.nvim_del_autocmd(autocmds[1].id)

            vim.api.nvim_create_autocmd('BufWriteCmd', {
              buffer = args.buf,
              callback = function(ev)
                local ipynb = ev.match
                local dir = vim.fn.fnamemodify(ipynb, ':h')
                local base = vim.fn.fnamemodify(ipynb, ':t:r')
                local tmp_pattern = dir .. '/' .. base .. '_tmp_jupytext_*'

                -- Clean up stale tmp files from any previous failed saves
                for _, f in ipairs(vim.fn.glob(tmp_pattern, false, true)) do
                  vim.fn.delete(f)
                end

                -- First attempt: normal jupytext save
                original_write(ev)

                -- Check for new tmp files — jupytext creates <name>_tmp_jupytext_<pid>.ipynb
                -- when os.replace() fails because the target is locked
                local tmp_files = vim.fn.glob(tmp_pattern, false, true)
                if #tmp_files == 0 then
                  return -- save succeeded
                end

                -- Save failed due to file lock. Stop Pyright to release handles, then retry.
                vim.notify('Notebook save blocked by file lock. Stopping Pyright and retrying...', vim.log.levels.WARN)

                local pyright_clients = vim.lsp.get_clients { name = 'pyright' }
                for _, client in ipairs(pyright_clients) do
                  client:stop()
                end

                if #pyright_clients > 0 then
                  vim.wait(3000, function()
                    return #vim.lsp.get_clients { name = 'pyright' } == 0
                  end, 50)
                end

                -- Clean up tmp files from the failed first attempt
                for _, f in ipairs(tmp_files) do
                  vim.fn.delete(f)
                end

                -- Retry save with Pyright stopped
                original_write(ev)

                -- Check if retry succeeded
                local retry_tmp = vim.fn.glob(tmp_pattern, false, true)
                if #retry_tmp > 0 then
                  -- Still failing — restore modified flag so user knows buffer is unsaved
                  -- (jupytext unconditionally sets modified=false even on failure)
                  vim.api.nvim_set_option_value('modified', true, { buf = vim.api.nvim_get_current_buf() })
                  vim.notify('Notebook save failed even after stopping Pyright. Check file locks.', vim.log.levels.ERROR)
                  for _, f in ipairs(retry_tmp) do
                    vim.fn.delete(f)
                  end
                else
                  vim.notify('Notebook saved successfully after Pyright restart.', vim.log.levels.INFO)
                end

                -- Restart Pyright
                if #pyright_clients > 0 then
                  vim.defer_fn(function()
                    vim.cmd 'LspStart pyright'
                  end, 500)
                end
              end,
            })
          end,
        })
      end
    end,
  },

  -- molten-nvim: execute code via Jupyter kernels with inline output
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    build = ':UpdateRemotePlugins',
    lazy = false, -- remote plugin; commands registered via rplugin manifest at startup
    init = function()
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = false
      vim.g.molten_auto_image_popup = true -- auto-open images in system viewer on cell completion
    end,
    keys = {
      { '<leader>ji', ':MoltenInit<CR>', desc = '[J]upyter [I]nit kernel' },
      { '<leader>jo', ':MoltenShowOutput<CR>', desc = '[J]upyter show [O]utput' },
      { '<leader>jh', ':MoltenHideOutput<CR>', desc = '[J]upyter [H]ide output' },
      { '<leader>jd', ':MoltenDelete<CR>', desc = '[J]upyter [D]elete cell' },
      { '<leader>jp', ':MoltenImagePopup<CR>', desc = '[J]upyter image [P]opup' },
    },
  },

  -- NotebookNavigator.nvim: cell navigation, execution, and manipulation
  {
    'vandalt/NotebookNavigator.nvim',
    dependencies = {
      'benlubas/molten-nvim',
    },
    ft = 'python', -- jupytext sets ft=python on .ipynb buffers (buffer name stays .ipynb)
    config = function()
      -- Draw horizontal separator lines above # %% markers using extmarks
      local ns = vim.api.nvim_create_namespace 'notebook_cell_separator'
      vim.api.nvim_set_hl(0, 'NotebookCellSeparator', { link = 'WinSeparator' })

      local function update_cell_separators(buf)
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local sep = string.rep('─', vim.o.columns)
        for i, line in ipairs(lines) do
          if line:match '^# %%%%' then
            vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
              virt_lines_above = true,
              virt_lines = { { { sep, 'NotebookCellSeparator' } } },
            })
          end
        end
      end

      vim.api.nvim_create_autocmd({ 'FileType' }, {
        pattern = 'python',
        callback = function(args)
          update_cell_separators(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'TextChanged', 'TextChangedI' }, {
        callback = function(args)
          if vim.bo[args.buf].filetype == 'python' then
            update_cell_separators(args.buf)
          end
        end,
      })

      -- Update separators in the current buffer immediately
      update_cell_separators(vim.api.nvim_get_current_buf())

      -- Custom molten repl handler that fixes output placement.
      -- The built-in handler passes end_line+1 to MoltenEvaluateRange, which places
      -- output one line into the next cell. This version passes the exact range with
      -- an explicit end column to avoid both the offset and truncation issues.
      local function molten_repl(start_line, end_line, _repl_args, _cell_marker)
        -- Trim trailing blank lines so output appears right below the last code line
        while end_line > start_line and vim.fn.getline(end_line):match '^%s*$' do
          end_line = end_line - 1
        end
        local end_col = #vim.fn.getline(end_line) + 1
        vim.fn.MoltenEvaluateRange(start_line, end_line, 1, end_col)
        return true
      end

      require('notebook-navigator').setup {
        repl_provider = molten_repl,
        cell_markers = {
          python = '# %%',
        },
      }
    end,
    keys = {
      {
        ']h',
        function()
          require('notebook-navigator').move_cell 'd'
        end,
        desc = 'Next cell',
      },
      {
        '[h',
        function()
          require('notebook-navigator').move_cell 'u'
        end,
        desc = 'Previous cell',
      },
      {
        '<leader>jx',
        function()
          require('notebook-navigator').run_cell()
        end,
        desc = '[J]upyter e[X]ecute cell',
      },
      {
        '<leader>jr',
        function()
          require('notebook-navigator').run_and_move()
        end,
        desc = '[J]upyter [R]un cell and move',
      },
      {
        '<leader>ja',
        function()
          require('notebook-navigator').run_cells_above()
        end,
        desc = '[J]upyter run [A]ll cells above',
      },
    },
  },
}
