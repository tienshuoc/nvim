return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  config = function()
    -- MiniAi consumes the queries; configure only the scope selector here.
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
    })
    vim.keymap.set({ "x", "o" }, "as", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
    end)
  end,
}
