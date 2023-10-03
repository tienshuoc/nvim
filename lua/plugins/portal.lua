return {
    -- Motion jump locations for changelists.
    "cbochs/portal.nvim",
    -- Optional dependencies
    dependencies = {
        "cbochs/grapple.nvim",
        "ThePrimeagen/harpoon",
    },
    keys = {
        { '<leader>o', '<cmd>Portal jumplist backward<cr>', mode = 'n', { noremap = true }},
        { '<leader>i', '<cmd>Portal jumplist forward<cr>', mode = 'n', { noremap = true }},
    },


}
