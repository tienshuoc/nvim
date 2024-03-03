return {
  -- Escape insert mode quickly with customized key combination without lag.
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup {
      mapping = { "yy", "jj" },        -- a table with mappings to use
      timeout = 200,                   -- the time in which the keys must be hit in ms. Use `vim.o.timeoutlen` by default
      clear_empty_lines = false,       -- clear line after escaping if there is only whitespace
      keys = "<Esc>",                  -- keys used for escaping, if it is a function will use the result everytime
    }
  end,
}
