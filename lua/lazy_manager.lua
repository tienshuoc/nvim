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
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
