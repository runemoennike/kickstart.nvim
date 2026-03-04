-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- Lazy load only when opening Python files
  ft = { 'python' },
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Required for parsing launch.json with comments
    'nvim-lua/plenary.nvim',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<leader>ds',
      function()
        require('dap').continue()
      end,
      desc = '[D]ebug [S]tart/Continue',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = '[D]ebug Step [I]nto',
    },
    {
      '<leader>do',
      function()
        require('dap').step_over()
      end,
      desc = '[D]ebug Step [O]ver',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_out()
      end,
      desc = '[D]ebug Step [O]ut',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = '[D]ebug Toggle [B]reakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = '[D]ebug Conditional [B]reakpoint',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = '[D]ebug Toggle [U]I',
    },
    {
      '<leader>de',
      function()
        require('dapui').eval()
      end,
      mode = { 'n', 'v' },
      desc = '[D]ebug [E]valuate expression',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.open()
      end,
      desc = '[D]ebug Open [R]EPL',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = '[D]ebug [T]erminate',
    },
    {
      '<leader>dh',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = '[D]ebug [H]over variable',
    },
    {
      '<leader>dp',
      function()
        require('dap').pause()
      end,
      desc = '[D]ebug [P]ause',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_to_cursor()
      end,
      desc = '[D]ebug Run to cursor [L]ine',
    },
    {
      '<leader>dk',
      function()
        require('dap').up()
      end,
      desc = '[D]ebug Up call stac[K]',
    },
    {
      '<leader>dj',
      function()
        require('dap').down()
      end,
      desc = '[D]ebug Down call stack [J]',
    },
    {
      '<leader>dx',
      function()
        require('dap').clear_breakpoints()
      end,
      desc = '[D]ebug Clear all breakpoints [X]',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'debugpy',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Load launch.json configurations from .vscode/launch.json if it exists
    -- This allows per-project debug configurations
    local vscode = require 'dap.ext.vscode'
    local json = require 'plenary.json'
    vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str))
    end
    -- Automatically load .vscode/launch.json when present
    if vim.fn.filereadable '.vscode/launch.json' == 1 then
      vscode.load_launchjs(nil, { debugpy = { 'python' }, python = { 'python' } })
    end

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Install Python specific config
    -- Use debugpy installed by Mason
    local debugpy_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/Scripts/python'
    if vim.fn.has 'unix' == 1 then
      debugpy_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
    end
    require('dap-python').setup(debugpy_path)

    -- Custom Python configuration with uv support
    -- This allows setting custom command line arguments when debugging
    table.insert(dap.configurations.python, 1, {
      type = 'python',
      request = 'launch',
      name = 'Launch file with arguments',
      program = '${file}',
      args = function()
        local args_string = vim.fn.input 'Arguments: '
        return vim.split(args_string, ' +')
      end,
      console = 'integratedTerminal',
      justMyCode = false,
    })

    -- Configuration for running a module (python -m)
    table.insert(dap.configurations.python, 2, {
      type = 'python',
      request = 'launch',
      name = 'Launch module with arguments',
      module = function()
        return vim.fn.input 'Module name: '
      end,
      args = function()
        local args_string = vim.fn.input 'Arguments: '
        return vim.split(args_string, ' +')
      end,
      console = 'integratedTerminal',
      justMyCode = false,
    })
  end,
}
