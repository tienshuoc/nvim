return {
  -- Requires:
  --  * Neovim 0.12+
  --  * tree-sitter CLI
  "romus204/tree-sitter-manager.nvim",
  config = function()
    require("tree-sitter-manager").setup()
  end,
}
