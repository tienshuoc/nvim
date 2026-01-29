# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive Neovim configuration that supports both standalone Neovim and VSCode Neovim extension usage. The configuration is built around Lazy.nvim plugin manager and includes extensive LSP, debugging, and UI customization.

## Architecture

### Core Bootstrap Process
1. **init.lua**: Entry point that detects environment (VSCode vs standalone) and handles large file optimization
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
- `vim.g.is_large_file_on_startup`: Disables heavy features for large files (>10MB)
- Standard mode: Full plugin suite

### Large File Optimization
Files exceeding the configured threshold (default: 10MB) automatically trigger performance optimizations:
- Size threshold is easily configurable in `lua/utils/handle_large_file.lua`
- All large file detection and handling logic centralized in the `handle_large_file` module
- Automatically disables heavy plugins (treesitter, LSP, completion, git integrations, themify, etc.)
- Disables performance-intensive features (swap, undo, syntax highlighting, folding)
- Detection works for both startup files and files opened during the session

### Colorscheme Management
- Managed by **Themify.nvim** plugin with automatic persistence
- 25+ colorschemes configured in `lua/plugins/themify.lua`
- Custom FzfLua integration provides fuzzy finding with live preview
- Keybindings:
  - `<leader>fc`: FzfLua fuzzy finder with live preview (as you navigate, colorschemes apply instantly)
  - `<leader>T`: Themify's built-in colorscheme switcher
- Each colorscheme's `before` hooks ensure proper setup (vim.g settings, require().setup() calls)
- Automatically disabled for large files to maintain performance

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