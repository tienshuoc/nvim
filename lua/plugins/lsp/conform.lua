return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  -- lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- Starting to edit / New File.
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>F",
      function()
        require("conform").format({ timeout_ms = 3000, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format current buffer.",
    },
  },
  config = function()
    require("conform").setup({
      formatters = {
        -- Self-defined formatters.
        jsonnet_indent4 = {
          command = "jsonnetfmt",
          args = {
            "--indent",
            "4",
            "-",
          },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettierd", "prettier" },
        cpp = { "clang-format" },
        jsonnet = { "jsonnet_indent4" },
      },
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        if vim.bo.filetype ~= "lua" and vim.bo.filetype ~= "jsonnet" then
          -- Don't format any file on save other than lua, jsonnet.
          return
        end
        require("conform").format({
          bufnr = args.buf,
        })
      end,
    })
  end,
}
