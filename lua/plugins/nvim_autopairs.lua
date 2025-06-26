return {
  "windwp/nvim-autopairs",
  cond = not vim.g.is_large_file_on_startup,
  event = "InsertEnter",
  config = true,
  -- use opts = {} for passing setup options
  -- this is equalent to setup({}) function
}
