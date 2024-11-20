return {
  -- Adds virtual text support to nvim-dap. Displays variables' values beside their definitions.
  "theHamsta/nvim-dap-virtual-text",
  lazy = true,
  config = function()
    require("nvim-dap-virtual-text").setup()
  end,
}
