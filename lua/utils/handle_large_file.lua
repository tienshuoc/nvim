-- Don't create swapfiles for *.log, *.mlir files.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.log", "*.mlir", "*.log.gz" },
  callback = function()
    vim.opt_local.swapfile = false
  end,
})

-- [[ Configure for Large Files ]]
-- This module centralizes all large file handling logic.
-- Files larger than the configured threshold will have performance optimizations applied.

local M = {}

-- Configuration
M.config = {
  size_threshold = 10 * 1024 * 1024, -- 10MB (easily modifiable)
}

-- List of plugins that are disabled for large files
-- These plugins have heavy performance impact and are skipped during large file loading
M.disabled_plugins = {
  "comment",
  "colorizer",
  "dashboard",
  "fidget",
  "flash",
  "gitsigns",
  "indent_blankline",
  "leetcode_nvim",
  "lualine",
  "marks",
  "mini_ai",
  "mini_clue",
  "mini_pairs",
  "neodim",
  "neoscroll",
  "nvim_autopairs",
  "nvim_cmp",
  "nvim_neo",
  "nvim_scrollbar",
  "overseer",
  "rainbow_delimiters",
  "treesitter",
  "treesitter_textobjects",
  "vim_illuminate",
  "yanky",
  "codecompanion",
}

-- Check if a file exceeds the size threshold
-- @param filepath string: Absolute path to the file
-- @return boolean: true if file is large, false otherwise
function M.is_large_file(filepath)
  if not filepath or filepath == "" then
    return false
  end

  local stat = vim.loop.fs_stat(filepath)
  return stat and stat.size > M.config.size_threshold
end

-- Apply performance-oriented settings for large files
function M.apply_large_file_settings()
  -- Use buffer-local settings so this only affects the current large file
  vim.opt_local.swapfile = false
  vim.opt_local.undofile = false
  vim.opt_local.spell = false
  vim.opt_local.relativenumber = false
  vim.opt_local.cursorline = false
  vim.opt_local.cursorcolumn = false
  vim.opt_local.foldmethod = "manual"
  vim.opt_local.foldenable = false

  -- These commands disable the syntax and filetype detection systems.
  vim.cmd("syntax off")
  vim.cmd("filetype off")

  vim.notify("Large file mode: Disabled swap, undo, syntax, and filetype.", vim.log.levels.WARN)
end

-- Set up large file detection for both startup and runtime
function M.setup()
  -- Initialize the global flag
  vim.g.is_large_file_on_startup = false

  -- Check if a large file was passed on startup
  local startup_file = vim.fn.argv()[1]
  if startup_file and vim.fn.filereadable(vim.fn.expand(startup_file)) == 1 then
    local filepath = vim.fn.fnamemodify(startup_file, ":p")
    if M.is_large_file(filepath) then
      vim.g.is_large_file_on_startup = true
    end
  end

  -- Set up autocommand to handle large files opened during the session
  -- Note: This only applies buffer-local settings. The argv check above is still
  -- needed to control plugin loading at startup (which happens before autocmds fire).
  local group = vim.api.nvim_create_augroup("LargeFileHandler", { clear = true })
  vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
    group = group,
    pattern = "*",
    callback = function(args)
      -- Skip if already checked this buffer
      if vim.b[args.buf].large_file_checked then
        return
      end

      local file = vim.fn.expand("<afile>")

      -- Skip empty paths and special buffers
      if file == "" or vim.bo[args.buf].buftype ~= "" then
        return
      end

      -- Get file size (-2 for directory, -1 for non-existent/unreadable)
      local size = vim.fn.getfsize(file)

      -- Mark buffer as checked to prevent duplicate checks
      vim.b[args.buf].large_file_checked = true

      if size > M.config.size_threshold then
        vim.b[args.buf].large_file = true
        M.apply_large_file_settings()
      end
    end,
  })
end

return M
