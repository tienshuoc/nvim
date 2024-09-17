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
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
  config = function()
    require("conform").setup({
      formatters = {
        clang_format = {
          command = "clang-format",
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettierd", "prettier" },
        cpp = { "clang_format" },
        jsonnet = { "jsonnetfmt" },
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
