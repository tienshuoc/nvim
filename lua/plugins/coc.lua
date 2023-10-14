local M = {
    'neoclide/coc.nvim',
    branch = 'release',
    build = "yarn install --frozen-lockfile",
    lazy = false,
}

M.config = function()
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

    -- coc-git
    keyset('n', '<leader>g', '<Plug>(coc-git-commit)', { noremap = true, silent = true })

    -- Command for Prettier formatting.
    -- vim.api.nvim_create_user_command("Prettier", "call CocActionAsync('runCommand', 'prettier.formatFile')", {})

    -------- COC extensions
    -- coc-yank : Highlights yanked text, persists yank list across vim instances.
    keyset("n", "<leader>yl", ":<C-u>CocList -A --normal yank<CR>", { silent = true })
    -- coc-tabnine
    -- coc-snippets
    -- coc-prettier
    -- coc-pairs
    -- coc-nav
    -- coc-lua
    -- coc-html
    -- coc-highlight
    -- coc-git
    -- coc-eslint
    -- coc-emmet
    -- coc-tsserver
    -- coc-tslint-plugin
    -- coc-python
    -- coc-markdownlint
    -- coc-markdown-preview-enhanced
    -- coc-json
end

return M
