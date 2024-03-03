# Requirements 🔨
Requires Nerd Font compatible font ( e.g. [Jet Brains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) ). Othewise, Devicons used may not render properly.

# File Structure 🗂️
## General Configs 🔧
* `lua/keymaps.lua` : Key mappings.
* `lua/options.lua` : Neovim option settings.
* `lua/ftsettings`: Specific settings by file type.
## Plugins 🔌
* `lua/lazy_manager.lua` : Entry point for Lazy neovim plugin manager.
* `lua/plugins/` : Assortment of plugins where each file corresponds to a single plugin and categorized plugins are grouped in folders.
* `lua/plugins/colorschemes/` : Directory containing colorscheme plugins (one per file).
  * [`Catpuccin 🍨`](https://github.com/catppuccin/nvim)
  * [`Darcula (JetBrains IDE theme) 🧶`](https://github.com/doums/darcula)
  * [`Dracula 🧛‍♂️`](https://github.com/Mofiqul/dracula.nvim)
  * [`Edge ⛰️`](https://github.com/sainnhe/edge)
  * [`Everforest 🌳`](https://github.com/neanias/everforest-nvim)
  * [`Github theme 🔃`](https://github.com/projekt0n/github-nvim-theme)
  * [`Gruvbox Material 🍂`](https://github.com/sainnhe/gruvbox-material)
  * [`Kanagawa 🌊`](https://github.com/rebelot/kanagawa.nvim)
  * [`Material 🪁`](https://github.com/marko-cerovac/material.nvim)
  * [`Monakai 🌸`](https://github.com/tanvirtin/monokai.nvim)
  * [`NightFox 🦊`](https://github.com/EdenEast/nightfox.nvim)
  * [`OneDark 🎨`](https://github.com/navarasu/onedark.nvim)
  * [`OneHalf 🌓`](https://github.com/sonph/onehalf)
  * [`PaperColor 📜`](https://github.com/NLKNguyen/papercolor-theme)
  * [`Rose Pine 🌹`](https://github.com/rose-pine/neovim)
  * [`Sonokai 🌺`](https://github.com/sainnhe/sonokai)
  * [`VSCode 🧢`](https://github.com/Mofiqul/vscode.nvim)

* `colorscheme_value`: Contains the current colorscheme value that's being used.
(E.g. `gruvbox-material`)
* `lua/manage_colorscheme.lua`:
    1. Reads from and set the editor colorscheme with value in `colorscheme_value`.
    2. Overwrites the value in `colorscheme_value` everytime there is a colorscheme change.
* `lua/plugins/dbg/` : All DAP ( Debugger Adapter Protocol ) settings.



# TODO 👀
* learn how to use `unimparied`
* [neodev]](https://github.com/folke/neodev.nvim) - Dev setup for neovim lua.
