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

if vim.g.vscode then
  require("lazy").setup({
    spec = {
      { import = "plugins.flash" },
      { import = "plugins.neoscroll" },
      { import = "plugins.mini_ai" },
      { import = "plugins.treesitter_textobjects" },
      { import = "plugins.treesitter" },
      { import = "plugins.surround" },
      { import = "plugins.yanky" },
    },
    { -- automatically check for plugin updates
      checker = { enabled = true },
    },
  })
elseif vim.g.is_large_file_on_startup then
  vim.notify("Large file detected, loading minimal set of plugins.", vim.log.levels.WARN)
  require("lazy").setup({
    { import = "plugins" },
  })
else
  require("lazy").setup({
    { import = "plugins.colorschemes" },
    { import = "plugins.git" },
    { import = "plugins.ftplugins" },
    { import = "plugins" },
    -- Debugger plugins.
    { import = "plugins.dbg" },
    { import = "plugins.dbg.lang" },
    -- Lsp plugins.
    { import = "plugins.lsp" },
  }, {
    checker = {
      enabled = true,
      notify = false,
    },
    change_detection = {
      notify = false,
    },
  })
end
