-- Don't create swapfiles for *.log, *.mlir files.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.log", "*.mlir", "*.log.gz" },
  callback = function()
    vim.opt_local.swapfile = false
  end,
})

-- [[ Configure for Large Files ]]
-- This setup will automatically disable certain features for files larger than 10MB
-- to improve performance.
local large_file_utils = {}

-- 1. Define a function to apply performance-oriented settings
function large_file_utils.apply_large_file_settings()
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

return large_file_utils
