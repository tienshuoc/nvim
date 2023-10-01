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


--local installed, lazy = pcall(require, "lazy")
--if not installed then
--	return
--end

require('lazy').setup({
    --------------------------- Colorschemes ---------------------------
    'tanvirtin/monokai.nvim',
    "EdenEast/nightfox.nvim",
    'projekt0n/github-nvim-theme',
    'ellisonleao/gruvbox.nvim',
    'Mofiqul/dracula.nvim',
    "catppuccin/nvim",
    "rebelot/kanagawa.nvim",
    "NLKNguyen/papercolor-theme",
    'Mofiqul/vscode.nvim',
    {
        "sonph/onehalf",
        rtp = "vim/",
        --[[ config = function() vim.cmd("colorscheme onehalflight") end       -- Comment out this line if not using this as the default theme. ]]
    },
    {'rose-pine/neovim', name = 'rose-pine'},

    ------------------------------- UI ---------------------------------
     -- hlargs (Highlight function arguments' definition and usages)
     'm-demare/hlargs.nvim',

    --lualine
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    --require('lualine').setup {
    --    sections = {
    --        lualine_z = { { 'datetime', style = '%H:%M:%S | %b-%d' } }
    --    }
    --},

    -- Color brackets.
    {
        'p00f/nvim-ts-rainbow',
        dependencies = { 'nvim-treesitter/nvim-treesitter' }
    },

    -- Indent blankline.
    "lukas-reineke/indent-blankline.nvim",

    -- Zen mode.
    'folke/zen-mode.nvim',

    -- Search > 99
    'google/vim-searchindex',

    ----------------------------- Terminal ----------------------------------

    {'akinsho/toggleterm.nvim', version = "*", config = true},

    ------------------ Editor Versioning & File Navigation ------------------
    -- Git
    'tpope/vim-fugitive',
    "sindrets/diffview.nvim",  -- Git diff page.
    'whiteinge/diffconflicts', -- Git diff conflicts.

    -- Fuzzy finder.
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        -- or                            , branch = '0.1.x',
        dependencies = {  'nvim-lua/plenary.nvim'  }
    },

    -- Buffer explorer.
    'jlanzarotta/bufexplorer',
    vim.keymap.set('n', '<leader>F', ':BufExplorer<CR>', { noremap = true, silent = true }),
    vim.keymap.set('n', '<leader>vsF', '<CR>:vs<CR>:BufExplorer<CR>', { noremap = true, silent = true }),
    vim.keymap.set('n', '<leader>sF', '<CR>:split<CR>:BufExplorer<CR>', { noremap = true, silent = true }),

    -- File explorer.
    'nvim-tree/nvim-tree.lua',
    'nvim-tree/nvim-web-devicons', -- Icons.
    -- vim.g.loaded_netrw = 1,
    -- vim.g.loaded_netrwPlugin = 1,
    -- require("nvim-tree").setup()
    vim.keymap.set('n', '<leader>nt', ':NvimTreeToggle<CR>', { noremap = true, silent = true }),

    -- Tagbar
    'preservim/tagbar',
    vim.keymap.set('n', '<leader>tb', ':TagbarToggle<CR>', { noremap = true, silent = true }),

    -- Buffer tabs
    'romgrk/barbar.nvim',
    vim.api.nvim_set_keymap('n', '<leader>G', '<Cmd>BufferPick<CR>', { noremap = true, silent = true }),
    vim.api.nvim_set_keymap('n', '<leader>D', '<Cmd>BufferPickDelete<CR>', { noremap = true, silent = true }),


    ----------------------------- Editing ------------------------------

    -- Comment
    'numToStr/Comment.nvim',

    -- JSX Context Commenting
    'JoosepAlviste/nvim-ts-context-commentstring',

    -- Surround
    {
	    "kylechui/nvim-surround",
	    version = "*", -- Use for stability; omit to use `main` branch for the latest features
	    event = "VeryLazy",
	    config = function()
		    require("nvim-surround").setup({
			    -- Configuration here, or leave empty to use defaults
		    })
	    end
    },

    -- Better syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },

    -- Display hex colors.
    'norcalli/nvim-colorizer.lua',

    -- Hop
    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    },


    --------------------------------------------- COC Code completion. (begin) ------------------------------------------------
    { 'neoclide/coc.nvim', branch = 'release' },


    --------------------------------------------- COC Code completion. (end) ------------------------------------------------

    --------------------------------------------------- Filetypes (begin) ---------------------------------------------------
    'neoclide/jsonc.vim',
    'mtdl9/vim-log-highlighting', -- Generic log file highlighting.

    --------------------------------------------------- Filetypes (end) -----------------------------------------------------

})
