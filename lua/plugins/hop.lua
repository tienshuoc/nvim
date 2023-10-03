return {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    keys = {

        { 'f', function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true }) end, mode = 'n', { remap = true } },
        { 'F', function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true }) end, mode = 'n', { remap = true } },
        { 't', function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, mode = 'n', { remap = true } },
        { 'T', function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end, mode = 'n', { remap = true } },

        { '<leader>hw', ':HopWordMW<CR>', mode = 'n', { noremap = true, silent = true } },
        { '<leader>ha', ':HopAnywhere<CR>', mode = 'n', { noremap = true, silent = true } },
        { '<leader>hp', ':HopPattern<CR>', mode = 'n', { noremap = true, silent = true } },

    },
    config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
}
