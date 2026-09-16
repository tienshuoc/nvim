-- faster.nvim owns large-file and long-line detection, feature toggles, and
-- macro acceleration. Keep config-specific integrations in its feature hooks.
return {
  "pteroctopus/faster.nvim",
  lazy = false, -- Register faster.nvim before the first file is read.
  config = function()
    -- Feature callbacks run in the affected buffer's context.
    local custom_features = {
      -- The built-in feature still uses the removed :LspStop/:LspStart commands.
      lsp = {
        disable = function()
          local buf = vim.api.nvim_get_current_buf()
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
            vim.lsp.buf_detach_client(buf, client.id)
          end
        end,
        enable = function()
          if vim.bo.filetype == "" then
            vim.notify("Restore filetype first with :Faster enable filetype", vim.log.levels.WARN)
            return
          end
          vim.api.nvim_exec_autocmds("FileType", { buffer = 0, modeline = false })
        end,
      },
      -- gitsigns: computes a diff on attach -> expensive on huge files.
      gitsigns = {
        on = true,
        defer = true, -- run at BufReadPost, after gitsigns would attach
        disable = function()
          pcall(vim.cmd, "Gitsigns detach")
        end,
        enable = function()
          pcall(vim.cmd, "Gitsigns attach")
        end,
      },
      -- colorizer: scans the buffer for color codes and highlights them.
      colorizer = {
        on = true,
        defer = false, -- Recheck after filetype changes in Faster's final disable pass.
        disable = function()
          pcall(vim.cmd, "ColorizerDetachFromBuffer")
        end,
        enable = function()
          pcall(vim.cmd, "ColorizerAttachToBuffer")
        end,
      },
      -- nvim-cmp: completion triggering while editing a large buffer.
      cmp = {
        on = true,
        defer = false,
        disable = function()
          local ok, cmp = pcall(require, "cmp")
          if ok then
            cmp.setup.buffer({ enabled = false })
          end
        end,
        enable = function()
          local ok, cmp = pcall(require, "cmp")
          if ok then
            cmp.setup.buffer({ enabled = true })
          end
        end,
      },
    }

    require("faster").setup({
      behaviours = {
        bigfile = {
          on = true,
          filesize = 10, -- MiB; long-line detection keeps faster.nvim's defaults.
          pattern = "*",
          features_disabled = {
            -- faster.nvim built-ins
            "illuminate", -- vim_illuminate
            "matchparen",
            "lsp",
            "treesitter",
            "indent_blankline",
            "vimopts",
            "syntax",
            "filetype",
            -- custom features defined below
            "gitsigns",
            "colorizer",
            "cmp",
          },
          extra_patterns = {},
        },
        longline = {
          -- Keep the built-in feature list and disable colorizer here too.
          features_disabled = {
            "illuminate",
            "matchparen",
            "lsp",
            "treesitter",
            "indent_blankline",
            "vimopts",
            "syntax",
            "filetype",
            "colorizer",
          },
        },
        fastmacro = {
          on = true,
          features_disabled = { "lualine", "mini_clue" },
        },
      },
      features = custom_features,
    })
  end,
}
