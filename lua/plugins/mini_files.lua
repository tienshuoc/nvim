return {
  "nvim-mini/mini.files",
  version = "*",
  keys = {
    {
      "<leader>mf",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0)) -- Open directory of current file (in last used state) focused on the file
      end,
      desc = "Open MiniFiles",
    },
  },
  opts = {},
}
