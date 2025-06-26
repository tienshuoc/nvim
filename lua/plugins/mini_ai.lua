return {
  "echasnovski/mini.ai",
  cond = not vim.g.is_large_file_on_startup,
  version = false,
  config = function()
    require("mini.ai").setup()
  end,
}
