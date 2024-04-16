return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require('harpoon')
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)                      -- Add current file to harpoon list.
    vim.keymap.set('n', '<leader>e', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end) -- Toggle harpoon list.
  end,
}
