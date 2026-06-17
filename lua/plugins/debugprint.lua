return {
  "rareitems/printer.nvim",
  keys = {
    { "gp", mode = { "n", "v" }, desc = "Debug print (printer.nvim operator)" },
  },
  config = function()
    require("printer").setup({
      keymap = "gp", -- Plugin doesn't have any keymaps by default
      -- function which modifies the text inside string in the print statement, by default it adds the path and line number
      add_to_inside = function(text)
        return string.format("[%s:%s] %s", vim.fn.expand("%:t"), vim.fn.line("."), text) -- Just print filename and line number. Full path might be too long.
      end,
    })
  end,
}
