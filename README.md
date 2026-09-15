# Neovim configuration

Personal configuration for standalone Neovim and the VS Code Neovim extension. Linux is the tested environment. This README is the maintained project reference for contributors and coding assistants.

[DeepWiki documentation](https://deepwiki.com/tienshuoc/nvim/1-overview)

## Requirements

- **Neovim 0.12+**. Recent configuration checks used **0.12.1**. See [Neovim installation](https://github.com/neovim/neovim/blob/master/INSTALL.md).
- **Git 2.31+**, including for Diffview's Git support.
- **tree-sitter CLI and a C compiler** such as GCC or Clang to build parsers. See the [parser manager requirements](https://github.com/romus204/tree-sitter-manager.nvim#requirements).
- **make** for the configured LuaSnip `jsregexp` build.
- **fzf** for pickers, **ripgrep (`rg`)** for text search, and **fd** for file search. This configuration uses [fzf-lua](https://github.com/ibhagwan/fzf-lua).
- **SQLite3's shared library** for Yanky's SQLite history backend. See [sqlite.lua installation](https://github.com/kkharji/sqlite.lua#installation).
- A [Nerd Font](https://www.nerdfonts.com/font-downloads) for the configured icons.

Mason also needs download and archive tools: on Linux, have `curl` or `wget`, `unzip`, GNU `tar`, and `gzip` available. Individual packages can require additional runtimes, such as Node.js/npm for Node-based language servers. See [Mason's requirements](https://github.com/mason-org/mason.nvim#requirements) and run `:checkhealth mason`.

## Installation

For a fresh install, clone into Neovim's configuration directory:

```bash
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
git clone https://github.com/tienshuoc/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

Lazy.nvim bootstraps itself on first launch. Open `:Lazy` to inspect installation, or use `:Lazy install` to install missing plugins. Run `:checkhealth` after installation.

Mason's configured installation lists include clangd, LuaLS, Pyright, BashLS, Starpls, rust-analyzer, and CodeLLDB. Other tools declared in [Conform's configuration](lua/plugins/lsp/conform.lua) must be installed through Mason or otherwise available on `PATH`; `:ConformInfo` shows their status. Feature-specific integrations also have their own prerequisites—for example, OpenCode uses its CLI and `lsof`.

## Startup profiles

- **Standalone:** `init.lua` loads options, Lazy, keymaps, search highlighting, and sessions. The ordinary plugin set loads for every file size.
- **VS Code:** when the extension sets `vim.g.vscode`, `lua/vscode_config.lua` supplies its own options and mappings. Lazy reads the same full specification but activates only the `vscode_plugins` allowlist in `lua/lazy_manager.lua`, including its required dependencies.

Both profiles share Lazy's plugin directory when they share `stdpath("data")`. Profile selection uses Lazy's native [`cond`](https://lazy.folke.io/spec#spec-loading), which skips loading standalone plugins in VS Code while keeping their installed directories and existing lockfile entries. `:Lazy clean` and the cleanup part of `:Lazy sync` can run from either profile; plugins removed from the full specification are still eligible for cleanup.

Install/update operations act on the active profile's plugins. Updates to a plugin used by both profiles affect both, since its checkout is shared.

When extending the VS Code subset, add the plugin's Lazy name and any required dependencies to `vscode_plugins`. A plugin's explicit `cond` overrides this default; use it deliberately for profile-specific exceptions.

## File layout

| Path | Purpose |
|---|---|
| [init.lua](init.lua) | Entry point and profile selection |
| [lua/lazy_manager.lua](lua/lazy_manager.lua) | Lazy bootstrap, shared imports, and profile selection |
| [lua/options.lua](lua/options.lua), [lua/keymaps.lua](lua/keymaps.lua) | Standalone options and mappings |
| [lua/vscode_config.lua](lua/vscode_config.lua) | VS Code-specific options and mappings |
| [lua/sessions.lua](lua/sessions.lua) | Session management |
| [lua/plugins/](lua/plugins/) | Plugin specs, including `lsp/`, `git/`, and `dbg/` |
| [lua/plugins/themify.lua](lua/plugins/themify.lua) | Theme installation, persistence, and the preview picker |
| [lua/plugins/ftplugins/](lua/plugins/ftplugins/) | Specs for filetype-support plugins |
| [after/ftplugin/](after/ftplugin/) | Local filetype overrides |
| [lua/utils/](lua/utils/) | Shared helpers, including Git links and Bazel LSP paths |

## Large files

[faster.nvim's configuration](lua/plugins/faster.lua) owns the **10 MiB** big-file threshold, the plugin's default long-line detection, and macro acceleration. There is no separate large-file startup scan or reduced plugin profile; the theme manager loads normally too.

Faster's feature hooks provide the local LSP, gitsigns, colorizer, and completion integrations. LSP detachment affects the current buffer; lualine and MiniClue suspension is limited to macro acceleration.

Use `:Faster status` to inspect state and `:Faster enable <feature>` to restore a feature manually. When restoring LSP individually, run `:Faster enable filetype` before `:Faster enable lsp`. Shrink recovery and cleanup follow the installed plugin's behavior; some built-in feature switches affect global state.

Incremental search stays enabled. [auto_hlsearch.lua](lua/utils/auto_hlsearch.lua) enables search highlighting for search keys and clears it on the next normal-mode key.

## Common mappings

The leader key is **Space**. These mappings apply to standalone Neovim:

| Mapping | Action |
|---|---|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move between panes (left/down/up/right), including LSP buffers |
| `K` / `gK` | Hover documentation / signature help in LSP buffers |
| `gd` / `grr` | Go to definition / references; single results jump directly, multiple results open fzf-lua |
| `<leader>ff` / `<leader>fg` | Find files / search file contents with fzf-lua |
| `<leader>fc` / `<leader>T` | Theme picker with preview / Themify UI; selection is persisted |
| `<leader>ih` | Toggle inlay hints for the buffer; hints are opt-in and excluded from diff and flagged large buffers |
| `<leader>F` | Format the current buffer or selection |
| `<leader>gU` | Copy a permalink for the current line or visual range |
| `<leader>gB` | Copy the blamed commit URL or a PR URL inferred from its subject |
| `<leader>mks1` … `<leader>mks9` / `<leader>mko1` … `<leader>mko9` | Save / load session slots 1–9 |

Session slots live at `~/s1.vim` through `~/s9.vim` by default. Change their directory and naming in [sessions.lua](lua/sessions.lua).

`gd` and `grr` jump directly through Neovim's native LSP handler when there is one result, preserving position encodings and the tag stack. With multiple results, the installed fzf-lua version can still jump to the wrong column after non-ASCII text when choosing from the picker.

The statusline diagnostic counts cover the current buffer, including both LSP and other Neovim diagnostic providers.

[Noice](lua/plugins/noice.lua) handles LSP progress notifications.

Git link helpers use the source file's repository and reject unsaved buffers. Their shared [Git utility](lua/utils/git.lua) captures the buffer and selection, runs queries from explicit directories, and checks the source buffer before copying. Permalinks also reject staged or on-disk changes to that file and check the file revision against local remote-tracking information.

## Themes

[Themify](lua/plugins/themify.lua) manages theme installation, per-theme settings, and the saved selection. Use `<leader>T` for its management UI or `<leader>fc` for fuzzy search with live preview. Selecting a theme saves it for the next startup; cancelling restores the colorscheme and background that were active when the picker opened, without changing the saved selection.

## C++ and MLIR

The native LSP setup lives in [nvim_lspconfig.lua](lua/plugins/lsp/nvim_lspconfig.lua). It uses `vim.lsp.config()` and one explicit `vim.lsp.enable()` server list. Mason handles installation and does not automatically enable additional servers.

For a CMake project, generate a compilation database and make it available at the checkout root. For example, with a Ninja or Makefiles generator:

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -s build/compile_commands.json compile_commands.json
```

See [clangd's project setup](https://clangd.llvm.org/installation.html#project-setup). The Bazel path adapter applies to clangd navigation replies in any detected Bazel workspace, including personal projects; it resolves execroot aliases only when they lead back into that workspace.

The MLIR server starts only when the owning checkout contains an executable `bazel-bin/compiler/shared/tools/unified-lsp-server`. It is a project build artifact, not a Mason-installed server.

For C++ debugging, `<leader>dc` starts or continues a session. The `Pick program and launch` configuration prompts for the executable and program arguments. Quote arguments containing spaces, for example `--input "path with spaces.mlir"`. Leave the arguments prompt empty to pass no arguments. Use `<leader>dui` to toggle the debugger panels without starting a session.

[The tool installer](lua/plugins/lsp/mason_tool_installer.lua) checks CodeLLDB, formatters, and linters during standalone startup and installs missing packages. The debugger loads on a debug mapping. Nvim-dap also reads `.vscode/launch.json` from the current working directory when starting a session. Use `:Mason` or `:MasonInstall codelldb` to manage the adapter installation.

## Plugin versions and updates

Lazy records installed plugin revisions in `lazy-lock.json`. **This repository currently ignores that file**, so each installation keeps its own local snapshot. `:Lazy restore` restores revisions from that local file; `:Lazy update` updates plugins and records their new revisions.

The lockfile covers Lazy-managed plugin revisions. Neovim, Mason packages, parser builds, and themes installed separately by Themify have their own versioning. See [Lazy's lockfile guidance](https://lazy.folke.io/usage/lockfile).

Use `:Mason` to manage external tools and `:TSManager` to manage parsers. The AsciiDoc grammar revisions are explicitly pinned in [tree_sitter_manager.lua](lua/plugins/tree_sitter_manager.lua) for compatibility with Markview's queries.

## Maintaining this configuration

Keep project guidance in this README so contributors and coding assistants use the same reference. When starting a coding-assistant session, ask it to read this file before making changes; automatic README loading depends on the tool.

- Make focused changes and check the actual plugin/API contracts. Preserve upstream LSP hooks when changing server overrides.
- Keep large-file management in faster.nvim's configuration and feature hooks.
- Preserve the Git helpers' parallel queries and session remote cache.
- Themify owns theme installation and persistence; theme-specific `before` hooks apply settings before loading their colorschemes.
- There is no repository test suite or application build step. Use relevant syntax/formatting checks and isolated headless Neovim checks for behavior changes. For documentation edits, review sources and links and run `git diff --check`.
- Restart Neovim for manual verification; re-sourcing a module can leave earlier callbacks or overrides active.
- Use `:Lazy install` for missing plugins and `:Lazy update` for deliberate updates. Plugin installation can run build commands and still requires the system tools listed above.
- Present each stage for review and obtain the repository owner's approval before committing.

## TODO 👀

* learn how to use `unimparied`
* https://github.com/folke/trouble.nvim
* https://github.com/folke/noice.nvim
* icons : https://www.lazyvim.org/configuration#icons--colorscheme
* https://github.com/SmiteshP/nvim-navbuddy
* https://github.com/folke/snacks.nvim : Collection of small quality of life plugins

* don't care about commit if file isn't changed for github url yanks
* neogit
* power of g (vimwiki)
* treewalker + mini.clue (reddit)
* linediff
