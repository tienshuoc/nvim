return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  -- lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- Starting to edit / New File.
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ timeout_ms = 3000 })
      end,
      mode = { "n", "v" },
      desc = "Format current buffer.",
    },
  },
  config = function()
    -- These can also be set directly
    require("conform").setup({
      formatters = {
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
