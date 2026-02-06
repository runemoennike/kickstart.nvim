-- dragdrop-nvim — open files dropped into Windows Terminal inside Neovim

local M = {}

local function normalize(txt)
  return txt:gsub('[\r\n]+', ''):gsub('^"(.*)"$', '%1')
end

-- Returns absolute path, normalized to match buffer paths
local function realpath(path)
  return vim.fn.fnamemodify(path, ':p') -- full absolute path
end

local function extract_paths(text)
  local paths = {}

  -- quoted paths
  for quoted in text:gmatch '"(.-)"' do
    table.insert(paths, quoted)
  end

  -- remove quoted ones
  local stripped = text:gsub('"(.-)"', '')

  -- bare paths
  for chunk in stripped:gmatch '%S+' do
    table.insert(paths, chunk)
  end

  return paths
end

-- Check if the absolute file path matches any buffer's full path
local function buffer_exists(abs_path)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= '' and vim.fn.fnamemodify(name, ':p') == abs_path then
        return true
      end
    end
  end
  return false
end

local function open_files(paths)
  for _, p in ipairs(paths) do
    local norm = normalize(p)
    if norm ~= '' and vim.fn.filereadable(norm) == 1 then
      local abs = realpath(norm)
      if not buffer_exists(abs) then
        vim.cmd('edit ' .. vim.fn.fnameescape(abs))
      end
    end
  end
end

function M.setup()
  local orig_paste = vim.paste

  vim.paste = function(lines, phase)
    if phase == -1 and lines and #lines == 1 then
      local text = lines[1]
      local paths = extract_paths(text)

      -- collect valid, existing files
      local valid = {}
      for _, p in ipairs(paths) do
        local norm = normalize(p)
        if vim.fn.filereadable(norm) == 1 then
          table.insert(valid, norm)
        end
      end

      if #valid > 0 then
        vim.schedule(function()
          open_files(valid)
        end)
        return true -- suppress insertion
      end

      return orig_paste(lines, phase)
    end

    return orig_paste(lines, phase)
  end
end

return M
