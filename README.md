# Requirements 🔨
* Nerd Font compatible font ( e.g. [Jet Brains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) ). Othewise, Devicons used may not render properly.
* [RipGrep](https://github.com/BurntSushi/ripgrep) for [full Telescope fuzzy-finding power](https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#required-dependencies).

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

# Installation 🗺️
📌 **WIP, currently just for UNIX/LINUX**
1. [Install Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) ( I currently use [`NVIM v0.9.4`](https://github.com/neovim/neovim/releases/tag/v0.9.4)).
2. Go to [`$XDG_CONFIG_HOME`](https://neovim.io/doc/user/starting.html#%24XDG_CONFIG_HOME). This is typically `~/.config` for Unix. <br>
This'll be the base root of where your Neovim configuration folder will reside.
```bash
cd ~/.config
```
3. Clone this `nvim/` folder into your config directory.
```bash
git clone https://github.com/tienshuoc/nvim.git
```
4. (WIP)


# TODO 👀
* learn how to use `unimparied`
* https://github.com/folke/trouble.nvim
* https://github.com/folke/noice.nvim
* icons : https://www.lazyvim.org/configuration#icons--colorscheme
* https://github.com/SmiteshP/nvim-navbuddy
* https://github.com/folke/snacks.nvim : Collection of small quality of life plugins
Vim in browser: https://github.com/glacambre/firenvim

* don't care about commit if file isn't changed for github url yanks
* neogit 
* power of g (vimwiki)
* treewalker + mini.clue (reddit)
* linediff


Clangd Generate compilation database:
```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
```
