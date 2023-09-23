-- Install Packer automatically if it's not installed(Bootstraping)
-- Hint: string concatenation is done by `..`
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()


-- Reload configurations if we modify plugins.lua
-- Hint
--     <afile> - replaced with the filename of the buffer being manipulated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])


-- Install plugins here - `use ...`
-- Packer.nvim hints
--     after = string or list,           -- Specifies plugins to load before this plugin. See "sequencing" below
--     config = string or function,      -- Specifies code to run after this plugin is loaded
--     requires = string or list,        -- Specifies plugin dependencies. See "dependencies".
--     ft = string or list,              -- Specifies filetypes which load this plugin.
--     run = string, function, or table, -- Specify operations to be run after successful installs/updates of a plugin
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    --------------------------- Colorschemes ---------------------------
    use 'tanvirtin/monokai.nvim'
    use "EdenEast/nightfox.nvim"
    use 'projekt0n/github-nvim-theme'
    use 'ellisonleao/gruvbox.nvim'
    use 'Mofiqul/dracula.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }
    use "rebelot/kanagawa.nvim"
    use "NLKNguyen/papercolor-theme"
    use {
        "sonph/onehalf",
        rtp = "vim/",
        config = function() vim.cmd("colorscheme onehalflight") end       -- Comment out this line if not using this as the default theme.
    }

    ------------------------------- UI ---------------------------------
    --lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    require('lualine').setup {
        sections = {
            lualine_z = { { 'datetime', style = '%H:%M:%S | %b-%d' } }
        }
    }

    -- Color brackets.
    use 'p00f/nvim-ts-rainbow'

    -- Indent blankline.
    use "lukas-reineke/indent-blankline.nvim"
    -- vim.opt.list = true
    -- vim.opt.listchars:append "eol:↴"
    --
    require("indent_blankline").setup {
        show_current_context = true,
        -- show_end_of_line = true,
    }

    -- Zen mode.
    use 'folke/zen-mode.nvim'

    -- Search > 99
    use 'google/vim-searchindex'

    ----------------------------- Terminal ----------------------------------
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end }


    ------------------ Editor Versioning & File Navigation ------------------
    -- Git
    use 'tpope/vim-fugitive'
    use "sindrets/diffview.nvim"  -- Git diff page.
    use 'whiteinge/diffconflicts' -- Git diff conflicts.

    -- Fuzzy finder.
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Buffer explorer.
    use 'jlanzarotta/bufexplorer'
    vim.keymap.set('n', '<leader>F', ':BufExplorer<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>vsF', '<CR>:vs<CR>:BufExplorer<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sF', '<CR>:split<CR>:BufExplorer<CR>', { noremap = true, silent = true })

    -- File explorer.
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons' -- Icons.
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup()
    vim.keymap.set('n', '<leader>nt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

    -- Tagbar
    use 'preservim/tagbar'
    vim.keymap.set('n', '<leader>tb', ':TagbarToggle<CR>', { noremap = true, silent = true })

    -- Buffer tabs
    use 'romgrk/barbar.nvim'
    vim.api.nvim_set_keymap('n', '<leader>G', '<Cmd>BufferPick<CR>', { noremap = true, silent = true })


    ----------------------------- Editing ------------------------------

    -- Comment
    use 'numToStr/Comment.nvim'

    -- JSX Context Commenting
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- Surround
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })

    -- Better syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- Display hex colors.
    use 'norcalli/nvim-colorizer.lua'

    -- Hop
    use {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    }
    -- place this in one of your configuration file(s)
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection
    vim.keymap.set('', 'f', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, { remap = true })
    vim.keymap.set('', 'F', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { remap = true })
    vim.keymap.set('', 't', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end, { remap = true })
    vim.keymap.set('', 'T', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    end, { remap = true })
    vim.keymap.set('n', '<leader>hw', ':HopWord<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>hv', ':HopVertical<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>hls', ':HopLineStart<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>hp', ':HopPattern<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>ha', ':HopAnywhere<CR>', { noremap = true, silent = true })


    --------------------------------------------- COC Code completion. (begin) ------------------------------------------------
    use { 'neoclide/coc.nvim', branch = 'release' }
    -- use {'neoclide/coc.nvim', branch = 'master', run = 'yarn install --frozen-lockfile'} -- Build from source.
    -- Some servers have issues with backup files, see #649
    vim.opt.backup = false
    vim.opt.writebackup = false

    -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    -- delays and poor user experience
    vim.opt.updatetime = 300

    -- Always show the signcolumn, otherwise it would shift the text each time
    -- diagnostics appeared/became resolved
    vim.opt.signcolumn = "yes"

    local keyset = vim.keymap.set
    -- Autocomplete
    function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end

    -- Use Tab for trigger completion with characters ahead and navigate
    local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

    keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
    keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

    -- Make <CR> to accept selected completion item or notify coc.nvim to format
    keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

    -- Use <c-j> to trigger snippets
    keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
    -- Use <c-space> to trigger completion
    keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

    -- Use `[g` and `]g` to navigate diagnostics
    -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
    keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

    -- GoTo code navigation
    keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
    keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
    keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
    keyset("n", "gr", "<Plug>(coc-references)", { silent = true })


    -- Use K to show documentation in preview window
    function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
            vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
            vim.fn.CocActionAsync('doHover')
        else
            vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
    end

    keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })


    --------------------------------------------- COC Code completion. (end) ------------------------------------------------

    --------------------------------------------------- Filetypes (begin) ---------------------------------------------------
    use('neoclide/jsonc.vim')
    use('mtdl9/vim-log-highlighting') -- Generic log file highlighting.

    --------------------------------------------------- Filetypes (end) -----------------------------------------------------

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)