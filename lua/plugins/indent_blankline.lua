--- Indent Blankline ---
return {
    "lukas-reineke/indent-blankline.nvim",
    keys = {
        { '<leader>tibl', ':IBLToggle<CR>', mode = 'n', { noremap = true } },
    },
    config = function()
        require("ibl").setup()
    end,
}

    -- -- vim.opt.list = true
    -- -- vim.opt.listchars:append "eol:↴"
    -- --
    -- require("indent_blankline").setup {
    --     show_current_context = true,
    --     -- show_end_of_line = true,
    -- }
