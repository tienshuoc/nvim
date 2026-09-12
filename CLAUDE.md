# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive Neovim configuration that supports both standalone Neovim and VSCode Neovim extension usage. The configuration is built around Lazy.nvim plugin manager and includes extensive LSP, debugging, and UI customization.

## Architecture

### Core Bootstrap Process
1. **init.lua**: Entry point that detects environment (VSCode vs standalone)
2. **lazy_manager.lua**: Configures Lazy.nvim plugin manager with different plugin sets based on environment
3. **themify.nvim**: Colorscheme manager with persistence and FzfLua integration for fuzzy finding with live preview

### Plugin Organization
- **lua/plugins/**: Individual plugin configurations (one plugin per file)
- **lua/plugins/lsp/**: LSP-related plugins (lspconfig, mason, conform, lint)
- **lua/plugins/git/**: Git integration plugins (fugitive, gitsigns, neogit)
- **lua/plugins/themify.lua**: Colorscheme manager with 25+ themes, FzfLua integration for live preview
- **lua/plugins/dbg/**: DAP debugging configurations

### Environment-Specific Loading
The configuration uses conditional loading based on:
- `vim.g.vscode`: Loads minimal plugins for VSCode extension
- Standard mode: Full plugin suite, including when opening large files

### Large File Optimization
**faster.nvim** (`lua/plugins/faster.lua`) owns large-file and long-line
classification, feature toggles, and macro acceleration. The big-file threshold
is configured there as 10 MiB; long-line detection uses the plugin's defaults.
There is no separate startup scan, reduced large-file plugin profile, or custom
classification/restoration utility.

The big-file feature list uses faster's built-in syntax, filetype, Tree-sitter,
matchparen, illuminate, indentation, and option handling, with custom hooks for
native Neovim LSP, gitsigns, colorizer, and completion. The LSP hook detaches only
the current buffer; enabling it re-enters native activation through FileType.
Lualine and MiniClue suspension is limited to macro acceleration.

Use `:Faster status` to inspect state and `:Faster enable <feature>` to restore
features manually. Restore `filetype` before `lsp` when enabling them individually.
Automatic recovery after shrinking a file, `:read` classification, and unload
cleanup follow the installed plugin's behavior; this configuration does not add
its own lifecycle callbacks. Inlay hints consult the plugin's big-file and
long-line trigger flags. Some built-in feature switches have global effects.

Search options are deliberately left alone for grep-ability: `incsearch` stays
on (its built-in half-second match timeout bounds the cost), and `hlsearch` is
auto-managed globally by `lua/utils/auto_hlsearch.lua` (on for search keys,
off on the next normal-mode key, via `vim.on_key`).

### Colorscheme Management
- Managed by **Themify.nvim** plugin with automatic persistence
- 25+ colorschemes configured in `lua/plugins/themify.lua`
- Custom FzfLua integration provides fuzzy finding with live preview
- Keybindings:
  - `<leader>fc`: FzfLua fuzzy finder with live preview (as you navigate, colorschemes apply instantly)
  - `<leader>T`: Themify's built-in colorscheme switcher
- Each colorscheme's `before` hooks ensure proper setup (vim.g settings, require().setup() calls)

## Key Configuration Files

- **lua/options.lua**: Core Neovim settings
- **lua/keymaps.lua**: Global key mappings
- **lua/sessions.lua**: Session management with configurable save/load keymaps
- **after/ftplugin/**: Filetype-specific configurations

## Plugin Dependencies

This configuration relies on Lazy.nvim for plugin management. The `lazy-lock.json` file pins specific plugin versions for reproducibility. No external build tools or package managers are required - Lazy.nvim handles all plugin installation and updates.

## Development Workflow

Since this is a Neovim configuration (not a development project), there are no build/test commands. Changes are applied by:
1. Editing configuration files
2. Restarting Neovim or running `:source %`
3. Using `:Lazy sync` to update plugins if needed

The configuration automatically handles plugin loading and applies settings based on the current environment and file context.