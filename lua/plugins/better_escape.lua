return {
  -- Escape insert mode quickly with customized key combination without lag.
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup({
      timeout = 200, -- the time in which the keys must be hit in ms. Use `vim.o.timeoutlen` by default
      default_mappings = false,
      mappings = {
        i = {
          j = {
            j = "<Esc>",
          },
          y = {
            y = "<Esc>",
          },
        },
      },
    })
  end,
}
