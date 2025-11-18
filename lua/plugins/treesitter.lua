return {
  -- Better syntax highlighting
  "nvim-treesitter/nvim-treesitter",
  cond = not vim.g.is_large_file_on_startup,
  lazy = false,
  event = {
    -- Lazy load when buffer open existing or non-existent file.
    "BufReadPre",
    "BufNewFile",
  },
  dependencies = {
    "OXY2DEV/markview.nvim",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = function()
    require("nvim-treesitter.install").update({ with_sync = false })()
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
        "html",
      },
      ignore_install = { "mlir" }, -- Tries to complain that you don't have "treesitter-cli", and installing it gives GLIBC problems. Back off for MLIR.
      sync_install = false,
      auto_install = false,
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
