-- Session management module
-- Provides convenient keymaps for saving and loading Neovim sessions

local M = {}

-- Configuration
M.config = {
  session_dir = vim.fn.expand("~"), -- Session directory (default: home directory)
  session_count = 6, -- Number of session slots
  session_prefix = "s", -- Session file prefix
  session_suffix = ".vim", -- Session file suffix
}

-- Set up session keymaps
function M.setup()
  for i = 1, M.config.session_count do
    local session_path = string.format(
      "%s/%s%d%s",
      M.config.session_dir,
      M.config.session_prefix,
      i,
      M.config.session_suffix
    )

    -- Save session keymap
    vim.keymap.set("n", "<leader>mks" .. i, function()
      vim.cmd("mksession! " .. session_path)
      vim.notify("Session saved to " .. session_path, vim.log.levels.INFO)
    end, { noremap = true, desc = "Save session " .. i })

    -- Load session keymap
    vim.keymap.set("n", "<leader>mko" .. i, function()
      if vim.fn.filereadable(session_path) == 1 then
        vim.cmd("source " .. session_path)
        vim.notify("Session loaded from " .. session_path, vim.log.levels.INFO)
      else
        vim.notify("Session file not found: " .. session_path, vim.log.levels.WARN)
      end
    end, { noremap = true, desc = "Load session " .. i })
  end
end

return M
