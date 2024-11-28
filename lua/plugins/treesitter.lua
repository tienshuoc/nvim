return {
  -- Better syntax highlighting
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  event = {
    -- Lazy load when buffer open existing or non-existent file.
    "BufReadPre",
    "BufNewFile",
  },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "typescript",
        "cpp",
        "json",
        "jsonc",
        "markdown",
        "gitcommit",
        "bash",
        "javascript",
        "python",
        "lua",
        "haskell",
      },
      ignore_install = { "mlir" }, -- Tries to complain that you don't have "treesitter-cli", and installing it gives GLIBC problems. Back off for MLIR.
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
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
