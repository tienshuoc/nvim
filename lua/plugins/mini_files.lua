return {
  "nvim-mini/mini.files",
  version = "*",
  keys = {
    {
      "<leader>mf",
      function()
        local path = vim.api.nvim_buf_get_name(0)
        if vim.bo.buftype ~= "" or path == "" then
          path = nil
        elseif not vim.uv.fs_stat(path) then
          local parent = vim.fs.dirname(path)
          path = parent and vim.fn.isdirectory(parent) == 1 and parent or nil
        end
        require("mini.files").open(path)
      end,
      desc = "Open MiniFiles",
    },
  },
  opts = {
    mappings = {
      go_in = "<Right>",
      go_out = "<Left>",
    },
  },
}
