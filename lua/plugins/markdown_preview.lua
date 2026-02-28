return {
  "iamcco/markdown-preview.nvim",
  -- lazy = false,
  -- priority = 49,
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_start = 0 -- Must be 0: auto_start=1 fires BufEnter autocommands that try to open a browser channel, crashing diffview.nvim when it opens markdown files.
    vim.g.mkdp_combine_preview = 1 -- Reuse previous opened preview window.
  end,
  ft = { "markdown" },
}
