return {
  -- Plugin to see progress of LSP.
  "linrongbin16/lsp-progress.nvim",
  config = function()
    require("lsp-progress").setup()
  end,
}
