return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_start = 1  -- Open the preview window after entering the Markdown buffer.
    vim.g.mkdp_combine_preview = 1  -- Reuse previous opened preview window.
  end,
  ft = { "markdown" },
}
