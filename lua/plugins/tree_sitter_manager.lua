return {
  -- Requires:
  --  * Neovim 0.12+
  --  * tree-sitter CLI
  "romus204/tree-sitter-manager.nvim",
  config = function()
    require("tree-sitter-manager").setup({
      ensure_installed = {
        "c",
        "cpp",
        "bash",
        "lua",
        "python",
        "diff",
        "dockerfile",
        "doxygen",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "html",
        "jsonnet",
        "lua",
        "llvm",
        "mlir",
        "markdown",
        "markdown_inline",
        "regex",
        "rust",
        "tablegen",
        "vimdoc",
        "vim",
      },
    })
  end,
}
