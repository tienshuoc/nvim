return {
  -- A task runner and job management plugin.
  -- E.g. Create a custom task that builds a C++ file.
  "stevearc/overseer.nvim",
  cond = not vim.g.is_large_file_on_startup,
  lazy = true,
  opts = {},
  config = function()
    require("overseer").setup()
  end,
}
