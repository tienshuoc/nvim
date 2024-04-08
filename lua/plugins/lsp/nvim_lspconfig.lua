return {
  "neovim/nvim-lspconfig",
  -- event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "p00f/clangd_extensions.nvim",
    {
      "SmiteshP/nvim-navic",
      config = function()
        vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
      end,
    }, -- A simple statusline/winbar component that uses LSP to show current node context.
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} }, -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  },
  opts = {
    inlay_hints = {
      enabled = true,
    },
  },
  config = function(_, opts)
    -- These have to be setup beforehand in this order.

    -- Setup language servers.
    local navic = require("nvim-navic")
    local lspconfig = require("lspconfig")
    -- local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }

        opts.desc = "Go to declaration."
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Go to definition."
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        opts.desc = "Go to references."
        vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)

        opts.desc = "Show documentation for under cursor."
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Go to implementation."
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

        opts.desc = "Displays signature information about the symbol under the cursor in a floating window."
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        -- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set("n", "<leader>wl", function()
        -- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        -- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

        opts.desc = "Renames all reference to symbol under cursor."
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "See available code actions."
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Formats a buffer using the attached (and optionally filtered) language server clients."
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end,
    }) -- LspAttach config.

    -- Change the Diagnostic symbols in the sign column (gutter).
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Used to enable autocompletion (assign to every lsp server config).
    local capabilities = cmp_nvim_lsp.default_capabilities()

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
      on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
        -- Inlay hints.
        if opts.inlay_hints.enabled then
          if client.supports_method("textDocument/inlayHint") then
            vim.toggle.inlay_hints(buffer, true)
          end
        end
      end,
    }) -- lua_ls.setup()

    lspconfig.pyright.setup({
      capabilities = capabilities,
    }) -- pyright.setup()

    lspconfig.tsserver.setup({
      capabilities = capabilities,
    }) -- tsserver.setup()

    lspconfig.clangd.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- Inlay hints.
        if opts.inlay_hints.enabled then
          if client.supports_method("textDocument/inlayHint") then
            vim.toggle.inlay_hints(buffer, true)
          end
        end
        navic.attach(client, bufnr)
      end, -- on_attach function()
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
    }) -- clangd.setup()
  end, -- config function()
}
