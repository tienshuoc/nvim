return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  -- Lazy replays VimEnter after loading, so the installer's startup check runs.
  event = "VimEnter",
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    -- Use Mason package names; Neovim owns LSP activation.
    integrations = {
      ["mason-lspconfig"] = false,
      ["mason-null-ls"] = false,
      ["mason-nvim-dap"] = false,
    },
    ensure_installed = {
      -- Language servers.
      "clangd",
      "lua-language-server",
      "pyright",
      "bash-language-server",
      "starpls",
      "rust-analyzer",
      -- Debugger, formatters, and linters.
      "codelldb",
      -- "prettier", -- Prettier formatter.
      "clang-format",
      "stylua", -- Lua formatter.
      "isort", -- python formatter
      "black", -- python formatter
      "shfmt", -- bash formatter
      "pylint",
      "eslint_d",
      "buildifier", -- bazel formatter
    },
  },
}
