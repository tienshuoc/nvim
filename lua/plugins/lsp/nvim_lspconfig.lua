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

-- Goto definition often takes us to files under the cache directory, we want to resolve symlinks first before making the jump.
-- A wrapper around the default LSP jump handler to resolve symlinks first.
if not vim.g._lsp_jump_handler_wrapped then
  local original_jump_handler = vim.lsp.util.show_document

  vim.lsp.util.show_document = function(location, ...)
    -- Check if the location is valid and has a URI
    if location and location.uri then
      local path = vim.uri_to_fname(location.uri)

      -- Use the modern, performant way to resolve symlinks.
      -- It returns (realpath, err), so we capture both for robust error handling.
      local realpath, err = vim.uv.fs_realpath(path)

      -- If resolution was successful and the path is different, update the location.
      if not err and realpath and realpath ~= path then
        location.uri = vim.uri_from_fname(realpath)
      elseif err then
        -- Optional: Notify the user if path resolution fails for some reason.
        -- This can be helpful for debugging unexpected behavior.
        vim.notify("LSP jump: Could not resolve path: " .. err.message, vim.log.levels.ERROR)
      else
        vim.notify("Unable to jump using realpath.")
      end
    end

    -- Call the original jump handler with the (potentially modified) location
    original_jump_handler(location, ...)
  end
  vim.g._lsp_jump_handler_wrapped = true -- set guard
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "p00f/clangd_extensions.nvim",
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
    -- local lspconfig = vim.lsp.config("*")

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { desc = "Go to previous diagnostic." }) -- This is native with NVIM0.10+
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { desc = "Go to next diagnostic." }) -- This is native with NVIM0.10+

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings with shared options
        local opts = { buffer = ev.buf, noremap = true, silent = true }

        vim.keymap.set(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          vim.tbl_extend("force", opts, { desc = "Go to declaration" })
        )
        vim.keymap.set(
          "n",
          "gd",
          require("fzf-lua").lsp_definitions,
          vim.tbl_extend("force", opts, { desc = "Go to definition" })
        )
        vim.keymap.set(
          "n",
          "grr",
          require("fzf-lua").lsp_references,
          vim.tbl_extend("force", opts, { desc = "Go to references" })
        ) -- Override default in Neovim 0.11
        vim.keymap.set(
          "n",
          "K",
          vim.lsp.buf.hover,
          vim.tbl_extend("force", opts, { desc = "Show documentation for under cursor" })
        )
        vim.keymap.set(
          "n",
          "gi",
          vim.lsp.buf.implementation,
          vim.tbl_extend("force", opts, { desc = "Go to implementation" })
        )
        vim.keymap.set(
          "n",
          "<C-k>",
          vim.lsp.buf.signature_help,
          vim.tbl_extend("force", opts, { desc = "Show signature information" })
        )
        vim.keymap.set(
          "n",
          "<leader>rn",
          vim.lsp.buf.rename,
          vim.tbl_extend("force", opts, { desc = "Rename symbol under cursor" })
        )
      end,
    }) -- LspAttach config.

    -- Change the Diagnostic symbols in the sign column (gutter).
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "󰠠",
          [vim.diagnostic.severity.HINT] = "",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
      },
    })

    -- Centralized server configurations
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            -- Make the language server recognize "vim" global
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      },
      pyright = {
        settings = {
          python = {
            pythonPath = vim.fn.exepath("python"),
          },
        },
      },
      bashls = {},
      -- ts_ls = {},  -- Uncomment to enable TypeScript language server
      clangd = {
        -- See `nvim/lua/plugins/lsp/clangd_config.yaml` for configurations.
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
          )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
            fname
          ) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        root_markers = {
          "compile_commands.json",
          "compile_flags.txt",
          "configure.ac", -- AutoTools
          "Makefile",
          "configure.ac",
          "configure.in",
          "config.h.in",
          "meson.build",
          "meson_options.txt",
          "build.ninja",
          ".git",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },
      rust_analyzer = {
        -- Note: do not set init_options for this LS config, it will be automatically populated by the contents of settings["rust-analyzer"]
      },
    }

    -- Setup all language servers with shared configuration
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    for server, config in pairs(servers) do
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
      }, config)
      vim.lsp.config(server, server_opts)
    end
  end, -- config function()
}
