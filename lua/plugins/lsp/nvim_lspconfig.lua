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
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim", -- Put installed server executables on PATH before activation.
    "p00f/clangd_extensions.nvim",
    "hrsh7th/cmp-nvim-lsp",
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

    vim.lsp.log.set_level("off") -- Disable log level to prevent generating large log files. Set to `vim.lsp.log.set_level("debug")` if debugging is needed.

    -- Load before LspAttach so Neovim installs its buffer reload cleanup.
    local inlay_hint = vim.lsp.inlay_hint
    local inlay_group = vim.api.nvim_create_augroup("lsp_inlay_hints", { clear = true })

    -- Hints belong to a buffer, including when Diffview reuses it in another tab.
    local function in_diff(buf)
      return vim.iter(vim.fn.win_findbuf(buf)):any(function(win)
        return vim.wo[win].diff
      end)
    end

    local function disable_inlay_hints_in_diff(ev)
      local buf = ev.buf == 0 and vim.api.nvim_get_current_buf() or ev.buf
      if in_diff(buf) and inlay_hint.is_enabled({ bufnr = buf }) then
        inlay_hint.enable(false, { bufnr = buf })
      end
    end

    vim.api.nvim_create_autocmd({ "BufWinEnter", "DiffUpdated" }, {
      group = inlay_group,
      callback = disable_inlay_hints_in_diff,
    })
    vim.api.nvim_create_autocmd("OptionSet", {
      group = inlay_group,
      pattern = "diff",
      callback = disable_inlay_hints_in_diff,
    })
    -- Diffview applies its window options after BufWinEnter.
    vim.api.nvim_create_autocmd("User", {
      group = inlay_group,
      pattern = "DiffviewDiffBufWinEnter",
      callback = disable_inlay_hints_in_diff,
    })

    local function inlay_hints_ok(buf)
      if not vim.api.nvim_buf_is_loaded(buf) or vim.b[buf].large_file or not vim.bo[buf].modifiable or in_diff(buf) then
        return false
      end
      -- Reject any non-file URI scheme (diffview://, fugitive://); the server
      -- cannot resolve those paths. A plain path or file:// is fine.
      local name = vim.api.nvim_buf_get_name(buf)
      local scheme = name:match("^(%a[%w+.-]*)://")
      if scheme and scheme ~= "file" then
        return false
      end
      return #vim.lsp.get_clients({ bufnr = buf, method = "textDocument/inlayHint" }) > 0
    end

    -- Keep hints opt-in; leaving a diff does not automatically re-enable them.
    vim.keymap.set("n", "<leader>ih", function()
      local buf = vim.api.nvim_get_current_buf()
      local enabled = inlay_hint.is_enabled({ bufnr = buf })
      if not enabled and not inlay_hints_ok(buf) then
        vim.notify("Inlay hints are unavailable for this buffer", vim.log.levels.WARN)
        return
      end
      inlay_hint.enable(not enabled, { bufnr = buf })
    end, { desc = "Toggle inlay hints (buffer)" })

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
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover({ border = "rounded" })
        end, vim.tbl_extend("force", opts, { desc = "Show documentation for under cursor" }))
        vim.keymap.set(
          "n",
          "gi",
          vim.lsp.buf.implementation,
          vim.tbl_extend("force", opts, { desc = "Go to implementation" })
        )
        vim.keymap.set("n", "<C-k>", function()
          vim.lsp.buf.signature_help({ border = "rounded" })
        end, vim.tbl_extend("force", opts, { desc = "Show signature information" }))
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

    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    local mlir_server = "bazel-bin/compiler/shared/tools/unified-lsp-server"

    -- Configure and enable only these servers; Mason handles installation.
    local servers = {
      clangd = {
        cmd = function(dispatchers, config)
          local cmd = {
            "clangd",
            "--background-index=false", -- avoid persistent cross-file indexing
            "-j=2",
            "--pch-storage=disk",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          }
          -- Use the owning checkout's compilation database when present.
          if config.root_dir and vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, "compile_commands.json")) then
            table.insert(cmd, "--compile-commands-dir=" .. config.root_dir)
          end
          local rpc = vim.lsp.rpc.start(cmd, dispatchers, {
            cwd = config.cmd_cwd or config.root_dir,
            env = config.cmd_env,
            detached = config.detached,
          })
          return require("utils.bazel_lsp_paths").wrap_rpc(rpc, config.root_dir)
        end,
        root_dir = function(bufnr, on_dir)
          if not vim.bo[bufnr].modifiable or not vim.uri_from_bufnr(bufnr):match("^file://") then
            return
          end
          -- Preserve the nearest checkout/build-database root used for Bazel.
          local root = vim.fs.root(bufnr, { "compile_commands.json", ".clangd", ".git" })
          if root then
            on_dir(root)
          end
        end,
      },
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
      starpls = {},
      rust_analyzer = {
        -- Note: do not set init_options for this LS config, it will be automatically populated by the contents of settings["rust-analyzer"]
      },
      -- The MLIR server is a build artifact of the software repo, and one
      -- docker container may host several checkouts (software1..software8).
      -- A fixed path would bind every buffer to whichever checkout the
      -- container booted from, so resolve the binary from the checkout that
      -- actually owns the buffer. Nothing starts when that checkout has not
      -- been built yet.
      mlir_lsp_server = {
        cmd = function(dispatchers, config)
          local bin = vim.fs.joinpath(config.root_dir, mlir_server)
          return vim.lsp.rpc.start({ bin }, dispatchers)
        end,
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, { "WORKSPACE", "MODULE.bazel", ".git" })
          -- Skip activation until this checkout has a runnable server.
          if root and vim.fn.executable(vim.fs.joinpath(root, mlir_server)) == 1 then
            on_dir(root)
          end
        end,
      },
    }

    for server, config in pairs(servers) do
      vim.lsp.config(server, config)
    end

    -- Share clangd's global settings with other clients through its standard path.
    local clangd_cfg_src = vim.fn.stdpath("config") .. "/lua/plugins/lsp/clangd_config.yaml"
    local clangd_cfg_dst = vim.fn.expand("~/.config/clangd/config.yaml")
    if vim.uv.fs_stat(clangd_cfg_src) and not vim.uv.fs_stat(clangd_cfg_dst) then
      vim.fn.mkdir(vim.fs.dirname(clangd_cfg_dst), "p")
      vim.uv.fs_symlink(clangd_cfg_src, clangd_cfg_dst)
    end

    vim.lsp.enable(vim.tbl_keys(servers))
  end, -- config function()
}
