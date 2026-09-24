return {
  "nvim-mini/mini.files",
  version = "*",
  keys = {
    {
      "<leader>mf",
      function()
        -- Use an existing parent for new/deleted files; virtual buffers start in cwd.
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
  config = function(_, opts)
    local files = require("mini.files")
    files.setup(opts)
    require("utils.buffer_path").register("minifiles", function(path_opts)
      -- Directory listing rows are not source-file line numbers.
      if path_opts and path_opts.line_ref then
        vim.notify("Line references are unavailable in MiniFiles", vim.log.levels.WARN)
        return
      end
      local entry = files.get_fs_entry()
      if not entry then
        vim.notify("Cursor is not on a filesystem entry", vim.log.levels.WARN)
        return
      end
      return entry.path
    end)
  end,
  opts = {
    mappings = {
      go_in = "<Right>",
      go_out = "<Left>",
    },
  },
}
