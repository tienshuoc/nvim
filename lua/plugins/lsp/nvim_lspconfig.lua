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

-- Bazel's compile_commands.json records the execroot as the compilation
-- directory, so clangd returns file URIs that point into the Bazel cache
-- (e.g. /scratch/.../execroot/_main/arc/foo.cpp) rather than the real
-- workspace paths. The execroot entries are symlinks back to the workspace,
-- so resolving them gives a canonical path the user recognises.
--
-- Two wrappers apply this resolution at different points in the LSP pipeline:
--
--   show_document      – called when jumping to a single location (gd, gD,
--                        gi). Rewrites location.uri before Neovim opens the
--                        buffer.
--
--   locations_to_items – called by fzf-lua (and the quickfix machinery) to
--                        build picker / location-list entries for results that
--                        return multiple locations (grr, etc.). Rewrites
--                        item.filename so the list shows real paths.
--
-- Note: external dependencies (e.g. LLVM headers fetched by Bazel) live as
-- real files in the cache with no symlink back to a nicer path, so they will
-- still appear with their full cache path.
--
-- Both wrappers are guarded so they are installed only once even if this
-- file is re-sourced.

local function resolve_path(path)
  -- fs_realpath resolves all symlink components and returns the canonical
  -- path, or nil on failure (e.g. file does not exist). Fall back to the
  -- original path so callers always get a usable string.
  return vim.uv.fs_realpath(path) or path
end

if not vim.g._lsp_jump_handler_wrapped then
  local original_show_document = vim.lsp.util.show_document

  vim.lsp.util.show_document = function(location, ...)
    if location and location.uri then
      local path = vim.uri_to_fname(location.uri)
      local realpath = resolve_path(path)
      if realpath ~= path then
        location.uri = vim.uri_from_fname(realpath)
      end
    end
    return original_show_document(location, ...)
  end

  local original_locations_to_items = vim.lsp.util.locations_to_items

  vim.lsp.util.locations_to_items = function(locations, offset_encoding)
    local items = original_locations_to_items(locations, offset_encoding)
    for _, item in ipairs(items) do
      if item.filename then
        item.filename = resolve_path(item.filename)
      end
    end
    return items
  end

  vim.g._lsp_jump_handler_wrapped = true
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
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

    local mlir_server = "bazel-bin/compiler/shared/tools/unified-lsp-server"

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

    -- Setup all language servers with shared configuration
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    for server, config in pairs(servers) do
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
      }, config)
      vim.lsp.config(server, server_opts)
    end

    -- Servers not managed by mason-lspconfig must be explicitly enabled.
    vim.lsp.enable("mlir_lsp_server")

    -- clangd is started via a FileType autocmd rather than the generic
    -- vim.lsp.config loop above. This lets us compute --compile-commands-dir
    -- at runtime from the actual project root instead of hardcoding a path.
    --
    -- Background: Bazel's compile_commands.json records the Bazel execroot as
    -- the compilation directory (e.g. /scratch/.../execroot/_main/). Without
    -- --compile-commands-dir, clangd either fails to locate compile_commands.json
    -- or builds its background index using those execroot paths. The editor
    -- opens files at their real workspace paths, so the index entries never
    -- match and cross-file "find references" only returns results from already-
    -- open buffers. Passing --compile-commands-dir with the real workspace root
    -- anchors clangd to the right compile_commands.json and ensures path
    -- consistency between the index and what the editor reports.
    --
    -- Global clangd configuration (inlay hints, warnings, hover, etc.) lives in
    -- lua/plugins/lsp/clangd_config.yaml. clangd only reads it from
    -- ~/.config/clangd/config.yaml, so ensure that path symlinks to the repo
    -- copy -- this keeps a single source of truth that also applies to other
    -- clangd clients (e.g. VSCode). Only created when absent, so a hand-managed
    -- file is never clobbered.
    local clangd_cfg_src = vim.fn.stdpath("config") .. "/lua/plugins/lsp/clangd_config.yaml"
    local clangd_cfg_dst = vim.fn.expand("~/.config/clangd/config.yaml")
    if vim.uv.fs_stat(clangd_cfg_src) and not vim.uv.fs_stat(clangd_cfg_dst) then
      vim.fn.mkdir(vim.fs.dirname(clangd_cfg_dst), "p")
      vim.uv.fs_symlink(clangd_cfg_src, clangd_cfg_dst)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("clangd_start", { clear = true }),
      pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
      callback = function()
        -- Walk up from the current buffer's path to find the project root.
        -- compile_commands.json is checked first so Bazel/CMake projects are
        -- rooted at the build database, not at .git (which may be higher up).
        local root = vim.fs.root(0, { "compile_commands.json", ".clangd", ".git" })
        if not root then
          return
        end -- not a recognised C/C++ project, skip

        if not vim.bo.modifiable then
          return
        end -- skip read-only buffers (e.g. diffview)

        local cmd = {
          "clangd",
          "--background-index=false", -- stop persistent cross-file indexing (main CPU/RAM hog)
          "-j=2", -- cap async worker threads to limit CPU spikes
          "--pch-storage=disk", -- keep preamble PCH on disk instead of RAM
          "--clang-tidy", -- surface clang-tidy diagnostics inline
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        }

        -- Only add --compile-commands-dir when compile_commands.json is
        -- present at the root. For projects that use .clangd or .git as their
        -- only root marker this flag would be wrong, so we skip it there.
        if vim.uv.fs_stat(root .. "/compile_commands.json") then
          table.insert(cmd, "--compile-commands-dir=" .. root)
        end

        -- Buffers that resolve to the same root_dir will share a single clangd
        -- process — vim.lsp.start reuses an existing client by default when
        -- both name and root_dir match.
        vim.lsp.start({
          name = "clangd",
          cmd = cmd,
          root_dir = root,
          capabilities = capabilities,
        })
      end,
    })
  end, -- config function()
}
