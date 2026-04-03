return {
  -- Better syntax highlighting
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false, -- The plugin currently doesn't support lazy-loading.
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "typescript",
        "cpp",
        "json",
        "jsonnet",
        "markdown",
        "gitcommit",
        "bash",
        "javascript",
        "python",
        "lua",
        "haskell",
        "html",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-s>",
          node_incremental = "<C-s>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}