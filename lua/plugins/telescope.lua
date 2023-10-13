--- Telescope (fuzzy finder) ---
return {
    'nvim-telescope/telescope.nvim', tag = '0.1.3',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { '<leader>ff', '<cmd>Telescope find_files<cr>', mode = 'n', { noremap = true }}, -- Find files.
        { '<leader>fg', '<cmd>Telescope live_grep<cr>', mode = 'n', { noremap = true }}, -- Grep amongst files.
        { '<leader>fb', '<cmd>Telescope buffers<cr>', mode = 'n', { noremap = true } }, -- Find files in buffer list.
        { '<leader>fh',  '<cmd>Telescope help_tags<cr>', mode = 'n', { noremap = true } }, -- Find help tags.
    },
    config = function()
        local telescope = require('telescope')
        telescope.setup({
            pickers = {
                colorscheme = {
                    enable_preview = true  -- Preview colorschemes with `:Telescope colorscheme`
                }
            },
            defaults = {
                path_display = {
                    shorten = {
                        len = 5,
                        exclude = { 1, -1 } -- Truncate to show 5 letters, except first and first to last.
                    }
                },
                wrap_results = true, -- Enable wrap around.
                mappings = {         -- Allow Ctrl-U to clear in insert mode.
                i = {
                    ["<C-u>"] = false
                },
            },
        },
    })
    -- require('telescope').load_extension('builtin') -- Load the 'builtin' extension
end,
}
