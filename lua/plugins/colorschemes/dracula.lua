return {
  -- dracula, dracula-soft
  "Mofiqul/dracula.nvim",
  config = function()
    require("dracula").setup({
      transparent_bg = false,
    })
  end,
}
