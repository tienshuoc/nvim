-------- README --------
-- colorscheme.lua : theme
-- keymaps.lua     : keymappings
-- lsp.lua         : LSP support
-- options.lua     : global options
-- plugins.lua     : third-party plugins
--____________________


--- Map Leader ---
vim.g.mapleader = ';';
vim.g.maplocalleader = ';';

-- Requires
require('options')
require('keymaps')
require('plugins')
require('colorscheme')

require('sn_options') -- SN options

--- Lazy ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Settings
--require('plugin_options/coc')
--require('plugin_options/comment')
--require('plugin_options/treesitter')
--require('plugin_options/indent_blankline')
--require('plugin_options/telescope')

-- Filetype Settings
require('ftplugin/typescript')
