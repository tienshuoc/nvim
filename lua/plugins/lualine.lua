return {
  -- Lualine
  "nvim-lualine/lualine.nvim",
  dependencies = { { "nvim-tree/nvim-web-devicons", opt = true }, "lsp-progress.nvim" },
  config = function()
    require("lualine").setup({
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "filename",
          {
            "diagnosticss",
            sources = { "nvim_lsp", "nvim_diagnostic", "nvim_workspace_diagnostic" }, -- Displays diagnostics for the defined severity types
            sections = { "error", "warn", "info", "hint" },

            diagnostics_color = {
              -- Same values as the general color option can be used here.
              error = "DiagnosticError", -- Changes diagnostics' error color.
              warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
              info = "DiagnosticInfo", -- Changes diagnostics' info color.
              hint = "DiagnosticHint", -- Changes diagnostics' hint color.
            },
            colored = true, -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = true, -- Show diagnostics even if there are none.
          },
        },
        lualine_c = {
          -- invoke `progress` here.
          function()
            return require("lsp-progress").progress()
          end,
        },
        lualine_x = { "diff", "branch", "filetype", "encoding" },
        lualine_y = { "progress" },
        lualine_z = { { "datetime", style = "%H:%M:%S | %b-%d" } },
      },
    })
    -- Listen lsp-progress event and refresh lualine.
    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "lualine_augroup",
      pattern = "LspProgressStatusUpdated",
      callback = require("lualine").refresh,
    })
  end,
}
