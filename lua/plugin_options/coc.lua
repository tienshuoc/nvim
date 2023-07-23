-- coc-git
keyset('n', '<leader>g', "<Plug>(coc-git-commit)", {})             -- Git commit info under cursor.

-- Command for Prettier formatting.
vim.api.nvim_create_user_command("Prettier", "call CocActionAsync('runCommand', 'prettier.formatFile')", {})
