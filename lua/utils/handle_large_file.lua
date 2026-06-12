-- [[ Configure for Large Files ]]
-- Settings for large files that faster.nvim does NOT cover. faster.nvim
-- (lua/plugins/faster.lua) owns per-buffer feature disabling and restoration:
-- syntax, filetype, treesitter, LSP, matchparen, illuminate, indent_blankline,
-- lualine, mini_clue, vimopts (swapfile, folds, undo, list, spell) + custom
-- gitsigns/colorizer/cmp features.
--
-- This module owns the complement:
--   * startup detection: vim.g.is_large_file_on_startup drives minimal plugin
--     loading in lua/lazy_manager.lua
--   * buffer-local options faster.nvim misses (wrap, synmaxcol, cursorline, ...)
--   * global perf options (lazyredraw), restored when the last large-file
--     buffer is deleted

local M = {}

-- Configuration. faster.nvim's bigfile.filesize derives from size_threshold --
-- change it here only.
M.config = {
  size_threshold = 10 * 1024 * 1024, -- 10MB (easily modifiable)
}

-- Check if a file exceeds the size threshold
-- @param filepath string: Path to the file
-- @return boolean: true if file is large, false otherwise
function M.is_large_file(filepath)
  if not filepath or filepath == "" then
    return false
  end

  local stat = vim.uv.fs_stat(filepath)
  return stat ~= nil and stat.size > M.config.size_threshold
end

-- lazyredraw has no buffer-local form; save it once on the first large file
-- and restore when the last large-file buffer is deleted. incsearch is left
-- alone: its built-in half-second match timeout bounds the cost, and turning
-- it off globally would also degrade search in normal buffers.
local saved_globals = nil

local function disable_global_opts()
  if saved_globals then
    return
  end
  saved_globals = { lazyredraw = vim.o.lazyredraw }
  vim.o.lazyredraw = true
end

local function restore_globals_if_no_large_buffers()
  if not saved_globals then
    return
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.b[buf].large_file then
      return
    end
  end
  vim.o.lazyredraw = saved_globals.lazyredraw
  saved_globals = nil
end

-- Buffer-local settings faster.nvim doesn't handle. Long lines are the main
-- redraw cost: no wrap, cap syntax column, no per-char features.
function M.apply_large_file_settings()
  vim.opt_local.relativenumber = false
  vim.opt_local.cursorline = false
  vim.opt_local.cursorcolumn = false
  vim.opt_local.wrap = false
  vim.opt_local.synmaxcol = 256
  vim.opt_local.colorcolumn = ""
  vim.opt_local.conceallevel = 0

  disable_global_opts()
end

-- Set up large file detection for both startup and runtime
function M.setup()
  -- is_large_file_on_startup drives minimal-plugin loading in lua/lazy_manager.lua
  -- (which happens before any autocmd can fire). Any large file among the args
  -- triggers it.
  vim.g.is_large_file_on_startup = false
  for _, arg in ipairs(vim.fn.argv()) do
    if vim.fn.filereadable(vim.fn.expand(arg)) == 1 and M.is_large_file(vim.fn.fnamemodify(arg, ":p")) then
      vim.g.is_large_file_on_startup = true
      break
    end
  end

  M.setup_apply_autocmd()
end

-- BufReadPre fires for startup arg files too (this is registered from init.lua
-- before the first file is read), so this single autocmd covers both the
-- startup and mid-session paths.
function M.setup_apply_autocmd()
  local group = vim.api.nvim_create_augroup("LargeFileHandler", { clear = true })

  vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
    group = group,
    pattern = "*",
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" then
        return
      end

      -- Re-check on every (re)read so a file that grew past the threshold
      -- since the first read is still caught.
      if not M.is_large_file(vim.api.nvim_buf_get_name(args.buf)) then
        return
      end

      local first_time = not vim.b[args.buf].large_file
      vim.b[args.buf].large_file = true
      M.apply_large_file_settings()

      if first_time then
        vim.notify(
          "Large file: applied option tweaks (heavy features disabled by faster.nvim).",
          vim.log.levels.WARN
        )
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      if vim.b[args.buf].large_file then
        -- The buffer is still listed during BufDelete; check after it's gone.
        vim.schedule(restore_globals_if_no_large_buffers)
      end
    end,
  })
end

return M
