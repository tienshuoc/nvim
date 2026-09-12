-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local spec
local minimal_startup = not vim.g.vscode and vim.g.is_large_file_on_startup

if vim.g.vscode then
  spec = {
    { import = "plugins.flash" },
    { import = "plugins.neoscroll" },
    { import = "plugins.mini_ai" },
    { import = "plugins.treesitter_textobjects" },
    { import = "plugins.tree_sitter_manager" },
    { import = "plugins.surround" },
    { import = "plugins.yanky" },
  }
elseif minimal_startup then
  local large_file = require("utils.handle_large_file")
  local threshold_mb = large_file.config.size_threshold / (1024 * 1024)
  vim.notify(
    string.format("Large file detected (>%.0fMB), loading minimal plugins.", threshold_mb),
    vim.log.levels.WARN
  )
  -- Explicit allowlist: only these plugin specs load in large-file mode. A spec
  -- file's declared dependencies still load automatically. Add an import line
  -- here to make a plugin available when starting with a large file.
  spec = {
    { import = "plugins.faster" }, -- per-buffer feature disabling for the large file
    { import = "plugins.fzf_lua" }, -- grepping/navigation
    { import = "plugins.marks" },
    { import = "plugins.wrapping_paper" },
    { import = "plugins.high_str" },
    { import = "plugins.mini_files" },
  }
else
  spec = {
    { import = "plugins.git" },
    { import = "plugins.ftplugins" },
    { import = "plugins" },
    { import = "plugins.dbg" },
    { import = "plugins.lsp" },
  }
end

require("lazy").setup(spec, {
  checker = {
    enabled = not minimal_startup,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
