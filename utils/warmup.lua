-- Pre-load every lazy.nvim plugin inside a throwaway headless session.
--
-- Why this exists:
--   This machine runs Microsoft Defender for Endpoint with DLP inspection.
--   The first time a plugin file is opened after a signature update it is fully
--   inspected, which costs ~16s across the whole plugin set. A second run moments
--   later costs ~1s, because Defender caches the scan result per file.
--
--   The usual fixes are unavailable here: Defender exclusions require local admin
--   (Tamper Protection is on) and Task Scheduler rejects task registration. So we
--   keep the scan cache warm from a background loop instead.
--
-- Run by utils/nvim-warmup.ps1 as:
--   nvim --headless -c "lua dofile(vim.env.NVIM_WARMUP_LUA)" -c "qa!"
--
-- Note: plugins with an `event`/`ft`/`keys` trigger are never loaded by a plain
-- headless start (no UI means no UIEnter, so `VeryLazy` never fires). Those are
-- exactly the files that end up cold, so we force-load all of them explicitly.

local ok, config = pcall(require, 'lazy.core.config')
if not ok then
  return
end

local names = {}
for name, _ in pairs(config.plugins) do
  names[#names + 1] = name
end

pcall(function()
  require('lazy').load { plugins = names }
end)
