-- Function to check if a floating dialog exists and if not
-- then check for diagnostics under the cursor
function OpenDiagnosticIfNoFloat()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end
  -- THIS IS FOR BUILTIN LSP
  vim.diagnostic.open_float(0, {
    scope = "cursor",
    focusable = false,
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertCharPre",
      "WinLeave",
    },
  })
end

return {
  "neovim/nvim-lspconfig",
  -- event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "p00f/clangd_extensions.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} }, -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  },
  config = function()
    -- Show diagnostics under the cursor when holding position
    vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      pattern = "*",
      command = "lua OpenDiagnosticIfNoFloat()",
      group = "lsp_diagnostics_hold",
    })
    -- These have to be setup beforehand in this order.

    vim.lsp.set_log_level("off") -- Disable log level to prevent generating large log files. Set to `vim.lsp.set_log_level("debug")` if debugging is needed.
    -- Enable inlay hints.
    vim.lsp.inlay_hint.enable(true)

    -- UI customization
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    -- Setup language servers.
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    -- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic in floating window." }) -- Conflicts with harpoon keymaps.
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic." }) -- This is native with NVIM0.10+
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic." }) -- This is native with NVIM0.10+

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }

        vim.keymap.set(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          vim.tbl_extend("force", opts, { desc = "Go to declaration." })
        )

        vim.keymap.set(
          "n",
          "gd",
          require("fzf-lua").lsp_definitions,
          vim.tbl_extend("force", opts, { desc = "Go to definition." })
        )

        vim.keymap.set(
          "n",
          "grr", -- Override the default keymapping for `lsp_go_to_references` in Neovim 0.11.
          require("fzf-lua").lsp_references,
          vim.tbl_extend("force", opts, { desc = "Go to references." })
        )

        -- This is native with NVIM0.10+
        vim.keymap.set(
          "n",
          "K",
          vim.lsp.buf.hover,
          vim.tbl_extend("force", opts, { desc = "Show documentation for under cursor." })
        )

        vim.keymap.set(
          "n",
          "gi",
          vim.lsp.buf.implementation,
          vim.tbl_extend("force", opts, { desc = "Go to implementation." })
        )

        vim.keymap.set(
          "n",
          "<C-k>",
          vim.lsp.buf.signature_help,
          vim.tbl_extend(
            "force",
            opts,
            { desc = "Displays signature information about the symbol under the cursor in a floating window." }
          )
        )

        vim.keymap.set(
          "n",
          "<leader>rn",
          vim.lsp.buf.rename,
          vim.tbl_extend("force", opts, { desc = "Renames all reference to symbol under cursor." })
        )

        vim.keymap.set(
          { "n", "v" },
          "<leader>ca",
          require("fzf-lua").lsp_code_actions,
          vim.tbl_extend("force", opts, { desc = "See available code actions." })
        )
      end,
    }) -- LspAttach config.

    -- Change the Diagnostic symbols in the sign column (gutter).
    -- vim.opt.ambiwidth = "double"
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "󰠠",
          [vim.diagnostic.severity.HINT] = "",
        },
        linehl = {
          -- [vim.diagnostic.severity.ERROR] = "ErrorMsg",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          [vim.diagnostic.severity.WARN] = "WarningMsg",
        },

        -- error = { text = "", texthl = "DiagnosticSignError", numhl = "" },
        -- warn = { text = "", texthl = "DiagnosticSignWarn", numhl = "" },
        -- hint = { text = "󰠠", texthl = "DiagnosticSignHint", numhl = "" },
        -- info = { text = "", texthl = "DiagnosticSignInfo", numhl = "" },
      },
    })

    -- Used to enable autocompletion (assign to every lsp server config).
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local default_on_attach_behavior = function(client, bufnr)
      -- Enable inlay hints if available.
      -- if client.server_capabilities.inlayHintProvider then
      --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      -- end
    end

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          -- Make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
      on_attach = default_on_attach_behavior,
    }) -- lua_ls.setup()

    lspconfig.pyright.setup({
      capabilities = capabilities,
      on_attach = default_on_attach_behavior,
      settings = {
        python = {
          -- pythonPath = vim.fn.exepath("python"),
          venvPath = "/opt/software/model_zoo/tests/venv/bin/python",
        },
      },
    }) -- pyright.setup()

    lspconfig.bashls.setup({
      capabilities = capabilities,
      on_attach = default_on_attach_behavior,
    })

    -- lspconfig.ts_ls.setup({
    --  capabilities = capabilities,
    --  on_attach = default_on_attach_behavior,
    -- }) -- tsserver.setup()

    lspconfig.clangd.setup({
      -- See `nvim/lua/plugins/lsp/clangd_config.yaml` for configurations.
      -- Make sure that there are no symlinks in `compile_command.json`. Otherwise GoTo Definition/Implementation wouldn't work until the file is opened once.
      capabilities = capabilities,
      on_attach = default_on_attach_behavior,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
      root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
          "Makefile",
          "configure.ac",
          "configure.in",
          "config.h.in",
          "meson.build",
          "meson_options.txt",
          "build.ninja"
        )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or require(
          "lspconfig.util"
        ).find_git_ancestor(fname)
      end,
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    }) -- clangd.setup()
  end, -- config function()
}
