-------- README --------
-- colorscheme.lua : theme
-- keymaps.lua     : keymappings
-- lsp.lua         : LSP support
-- options.lua     : global options
-- plugins.lua     : third-party plugins
--____________________


--- Map Leader ---
vim.g.mapleader = ' ';
vim.g.maplocalleader = ' ';

-- Requires
require('options')
require('keymaps')

-- Plugins
require('lazy_manager')




-- Colorscheme
-- Maintain file as single source of truth for current colors.
-- Contains a single line with colorscheme, e.g. gruvbox-material
local colorscheme_fname = vim.fn.expand(vim.fn.stdpath("config") .. "/colorscheme_value")
vim.cmd.colorscheme(vim.fn.readfile(colorscheme_fname)[1])
-- Define a function to write the current color scheme to a file
function write_color_scheme()
    local colorscheme = vim.g.colors_name
    -- local colorscheme_file = vim.fn.stdpath('config') .. '/last_colorscheme.vim'
    -- local cmd = string.format('echo "let g:colors_name = \'%s\'" > %s', colorscheme, colorscheme_file)
    -- vim.fn.system(cmd)
    vim.fn.writefile({ colorscheme }, colorscheme_fname)
end

-- Automatically execute the function when the color scheme changes
-- vim.cmd('autocmd ColorScheme * lua write_color_scheme()')
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        write_color_scheme()
    end,
})

require('sn_options') -- SN options

-- Filetype Settings
require('ftplugin/typescript')
require('ftplugin/mlir')
