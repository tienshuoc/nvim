-- Don't create swapfiles for *.log, *.mlir files.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.log", "*.mlir", "*.log.gz" },
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.modifiable = false
  end,
})

-- [[ Configure for Large Files ]]
--
-- This setup will automatically disable certain features for files larger than 10MB
-- to improve performance.

-- 1. Define a function to apply performance-oriented settings
local function apply_large_file_settings()
  -- Use buffer-local settings so this only affects the current large file
  vim.opt_local.swapfile = false
  vim.opt_local.undofile = false

  -- These commands disable the syntax and filetype detection systems.
  -- They are more effective than buffer-local options for this purpose.
  vim.cmd("syntax off")
  vim.cmd("filetype off")

  -- Notify the user that large file mode is active for this buffer
  vim.notify("Large file mode activated: Disabled swapfile, undofile, syntax, and filetype.", vim.log.levels.WARN)
end

-- 2. Create an autocommand group to ensure this doesn't get duplicated
local large_file_group = vim.api.nvim_create_augroup("LargeFileHandler", { clear = true })

-- 3. Create the autocommand itself
vim.api.nvim_create_autocmd("BufEnter", {
  group = large_file_group,
  pattern = "*", -- Apply to all files
  callback = function()
    -- Define the size limit (10MB in bytes)
    local size_limit = 10 * 1024 * 1024 -- 10MB

    -- Get the full path of the current buffer
    local file_path = vim.fn.expand("%:p")

    -- Proceed only if the file is readable and not a directory
    if file_path ~= "" and not vim.fn.isdirectory(file_path) and vim.fn.filereadable(file_path) == 1 then
      local file_size = vim.fn.getfsize(file_path)

      -- If the file size is larger than our limit, apply the settings
      if file_size > size_limit then
        apply_large_file_settings()
      end
    end
  end,
})
