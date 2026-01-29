### 🔗 [DeepWiki Documentation](https://deepwiki.com/tienshuoc/nvim/1-overview) 📑

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
* `lua/plugins/themify.lua` : Colorscheme manager with 25+ themes and FzfLua integration.
  * Includes themes: Catppuccin 🍨, Cyberdream 🤖, Darcula 🧶, Dracula 🧛‍♂️, Edge ⛰️, Eldritch ✨, Everforest 🌳, Flow 🌊, Github 🔃, Gruvbox Material 🍂, Kanagawa 🌊, Material 🪁, Melange 🎨, Miasma 🌫️, Modus 📖, Monokai 🌸, Moonfly 🌙, NightFox 🦊, OneDark 🎨, OneHalf 🌓, PaperColor 📜, Rose Pine 🌹, Sonokai 🌺, Sweetie 🍬, Tokyo Night 🌃, VSCode 🧢
  * **FzfLua Integration**: Press `<leader>fc` for fuzzy finding with live preview (colorschemes apply as you navigate)
  * **Persistence**: Selected colorscheme persists across Neovim sessions
  * **Before Hooks**: Each colorscheme properly configured with setup functions and vim.g settings
  * **Smart Loading**: Automatically disabled for large files (>10MB) to maintain performance
* `lua/plugins/dbg/` : All DAP ( Debugger Adapter Protocol ) settings.

# Installation 🗺️
📌 **WIP, currently just for UNIX/LINUX**
1. [Install Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) ( I currently use [`NVIM v0.11.0`](https://github.com/neovim/neovim/releases/tag/v0.11.0)).
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

* don't care about commit if file isn't changed for github url yanks
* neogit 
* power of g (vimwiki)
* treewalker + mini.clue (reddit)
* linediff


Clangd Generate compilation database:
```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
```
