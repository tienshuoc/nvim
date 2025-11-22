return {
  -- Edge Dark (default, aura, neon), Edge Light
  "sainnhe/edge",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    vim.g.edge_dim_inactive_windows = 1
    vim.g.edge_enable_italic = 1
    vim.g.edge_style = "neon"
    -- vim.g.edge_transparent_background = 1
  end,
}
