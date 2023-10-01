return {
    --Tagbar
    'preservim/tagbar',
    config = function()
        vim.keymap.set('n', '<leader>tb', ':TagbarToggle<CR>', { noremap = true, silent = true })
        -- require('tagbar').setup({})
    end,
}
