# nvim
## Requirements
Requires [Jet Brains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) installment.

## File Structure
`lua/keymaps.lua`: Key mappings.
`lua/options.lua`: Neovim option settings.

`lua/ftplugin`: Specific settings by file type.

`lua/lazy_manager.lua`: Entry point for Lazy neovim plugin manager.
`lua/plugins/`: Assortment of plugins where each file corresponds to a single plugin. (Apart from `g_` prefixed files, which are groups of plugins lightweight enough to occupy a single file.

### TODO
* Set keyboard to use OSC52 : https://neovim.io/doc/user/provider.html#provider-clipboard
* learn how to use `unimparied`
