# Neovim configuration

Personal configuration for standalone Neovim and VS Code Neovim on Linux. This is the maintained guide for contributors and coding assistants; read it before editing. Keep implementation rationale beside the code.

## Setup

- **Neovim 0.12+** and **Git 2.31+**.
- **tree-sitter CLI**, a C compiler, and **make** for parser and snippet builds.
- **fzf**, **ripgrep**, **fd**, **SQLite3's shared library**, and a Nerd Font for the configured pickers, yank history, and icons.
- Mason needs `curl` or `wget`, `unzip`, `tar`, and `gzip`. Individual tools may also need runtimes such as Node.js or Python.

```bash
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
git clone https://github.com/tienshuoc/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

Lazy bootstraps on first launch. Check `:Lazy` and `:checkhealth` after installation. OpenCode additionally needs its CLI and `lsof`.

## Where things live

| Area | Source |
|---|---|
| Startup and profile selection | [init.lua](init.lua), [lazy_manager.lua](lua/lazy_manager.lua) |
| Editor options and mappings | [options.lua](lua/options.lua), [keymaps.lua](lua/keymaps.lua) |
| VS Code and shared mappings | [vscode_config.lua](lua/vscode_config.lua), [keymaps_common.lua](lua/keymaps_common.lua) |
| Plugin setup, including Git and debugging | [lua/plugins/](lua/plugins/) |
| LSP activation and tool installation | [nvim_lspconfig.lua](lua/plugins/lsp/nvim_lspconfig.lua), [mason_tool_installer.lua](lua/plugins/lsp/mason_tool_installer.lua) |
| Large-file policies and feature hooks | [faster.lua](lua/plugins/faster.lua) |
| Theme installation, preview, and persistence | [themify.lua](lua/plugins/themify.lua) |
| Filetypes, local options, and queries | [ftdetect/](ftdetect/), [after/ftplugin/](after/ftplugin/), [queries/](queries/) |
| Path/Git helpers and session slots | [lua/utils/](lua/utils/), [sessions.lua](lua/sessions.lua) |

Both profiles declare the full plugin set. VS Code activates the allowlist in `lazy_manager.lua`; add required dependencies there too. Plugin checkouts are shared between profiles that use the same data directory.

## Common mappings

The leader key is **Space**. These are standalone mappings; MiniClue shows available key combinations as you type.

| Keys | Action |
|---|---|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move between panes |
| `jj` / `yy` (Insert) | Leave Insert mode when typed within 200 ms |
| `K` / `gK` | LSP hover / signature help |
| `gd` / `grr` | Definition / references |
| `af` / `if` | Function or method / body textobjects |
| `gc{motion}` / `gcc` / `gc` (Visual) | Native comment toggling |
| `<leader>ff` / `<leader>fg` / `<leader>mf` | Find files / grep / browse with MiniFiles |
| `<leader>fc` / `<leader>T` | Theme picker with live preview / Themify management |
| `<leader>ih` | Toggle inlay hints for the buffer |
| `<leader>F` | Format the buffer or selection |
| `[d` / `]d` | Previous / next diagnostic; counts supported |
| `[h` / `]h` | Previous / next staged or unstaged Git hunk; counts supported |
| `<leader>gg` / `<leader>ng` | Diffview / Neogit |
| `<leader>gU` / `<leader>gB` | Copy a permalink / blamed commit or inferred PR URL |
| `<leader>rp` / `<leader>yrp` / `<leader>yrd` | Show resolved path / copy it / copy its parent directory |
| `<leader>ywp` / `<leader>yfn` | Copy displayed file path / filename |
| `<leader>yln` / `<leader>yrln` | Copy relative / resolved path with line or selection range |
| `<leader>dc` / `<leader>dui` | Start or continue debugging / toggle debugger UI |
| `<leader>mks1` … `mks9` / `<leader>mko1` … `mko9` | Save / load session slots |

Path copies support Diffview panes and MiniFiles entries; line references require file contents. Session slots default to `~/s1.vim` through `~/s9.vim`.

## Tools and projects

- **Plugins:** `:Lazy install` for missing plugins; `:Lazy update` for deliberate updates.
- **Tools:** `:Mason` manages the packages listed in `mason_tool_installer.lua`. `:ConformInfo` shows formatter availability; additional formatters must be installed or on `PATH`.
- **Parsers:** `:TSManager` manages parsers; `:TSInstall mlir` installs MLIR support. The AsciiDoc pin's reason is documented in [tree_sitter_manager.lua](lua/plugins/tree_sitter_manager.lua).
- **Large files:** `:Faster status` shows active policies. Restore filetype before manually re-enabling LSP or rainbow delimiters.

clangd uses the owning checkout's `compile_commands.json`; see [project setup](https://clangd.llvm.org/installation.html#project-setup). MLIR servers are checkout-local build artifacts, with paths and selection in `nvim_lspconfig.lua`. The configured debugger requires **CodeLLDB 1.11+** and also reads `.vscode/launch.json`.

`lazy-lock.json` is intentionally ignored: each installation keeps its own snapshot, which `:Lazy restore` uses. Do not track or update it as part of configuration cleanup.

## Contributing

- Make focused changes, verify upstream APIs, and preserve upstream LSP hooks when overriding server configuration.
- Keep rationale and integration constraints near the implementation; use this README as the shared guide for coding tools.
- There is no repository test suite. Check Lua syntax and StyLua formatting, use isolated headless Neovim checks for behavior changes, and run `git diff --check`.
- Restart Neovim for manual verification; re-sourcing can leave old callbacks active.
- Present each stage for review before committing.
- Put shared changes on `main`. Keep machine-specific paths and version pins in the single work commit on `sn-dev-branch`; rebase it onto updated `main` when syncing. Preserve the work patch and use an explicit lease when pushing rewritten history.
