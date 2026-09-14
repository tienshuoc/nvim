return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  -- Lazy replays VimEnter after loading, so the installer's startup check runs.
  event = "VimEnter",
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    -- Use Mason package names without loading an optional DAP integration.
    integrations = { ["mason-nvim-dap"] = false },
    ensure_installed = {
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
