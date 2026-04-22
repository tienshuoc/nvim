-- Enable treesitter-based syntax highlighting for buffers with an available parser.
-- tree-sitter-manager.nvim only handles parser installation; this activates highlighting.
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    -- Skip ephemeral buffers (e.g. nvim-notify) to avoid neodim's TSOverride
    -- hitting "Invalid 'end_col': out of range" on short-lived content.
    if vim.bo.buftype ~= "" then
      return
    end
    -- Enable treesitter highlighting and disable regex syntax
    pcall(vim.treesitter.start)
  end,
})
