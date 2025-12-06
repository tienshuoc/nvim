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
  opts = {
    mappings = {
      close = "q",
      go_in = "<Right>",
      go_in_plus = "L",
      go_out = "<Left>",
      go_out_plus = "H",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },
  },
}
