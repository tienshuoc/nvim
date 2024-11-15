return {
  -- A task runner and job management plugin.
  -- E.g. Create a custom task that builds a C++ file.
  "stevearc/overseer.nvim",
  opts = {},
  config = function()
    require("overseer").setup()
  end,
}
