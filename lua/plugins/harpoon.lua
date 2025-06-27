return {
  "ThePrimeagen/harpoon",
  lazy = true,
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Add to Harpoon list.",
    },
    {
      "<leader>e",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Toggle Harpoon list.",
    },
    -- {
    --   "1",
    --   function()
    --     require("harpoon"):list():select(1)
    --   end,
    --   desc = "Select 1 in list.",
    -- },
    -- {
    --   "2",
    --   function()
    --     require("harpoon"):list():select(2)
    --   end,
    --   desc = "Select 2 in list.",
    -- },
    -- {
    --   "3",
    --   function()
    --     require("harpoon"):list():select(3)
    --   end,
    --   desc = "Select 3 in list.",
    -- },
    -- {
    --   "4",
    --   function()
    --     require("harpoon"):list():select(4)
    --   end,
    --   desc = "Select 4 in list.",
    -- },
  },
  opts = {},
}
