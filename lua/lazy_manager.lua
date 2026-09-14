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

-- Use Lazy plugin names, including dependencies needed by the VS Code subset.
local vscode_plugins = {
  ["lazy.nvim"] = true,
  ["flash.nvim"] = true,
  ["neoscroll.nvim"] = true,
  ["mini.ai"] = true,
  ["nvim-treesitter-textobjects"] = true,
  ["tree-sitter-manager.nvim"] = true,
  ["nvim-surround"] = true,
  ["yanky.nvim"] = true,
  ["sqlite.lua"] = true, -- Yanky's history backend.
}

-- Always declare the full set so profile changes do not make plugins look unused.
local spec = {
  { import = "plugins.git" },
  { import = "plugins.ftplugins" },
  { import = "plugins" },
  { import = "plugins.dbg" },
  { import = "plugins.lsp" },
}

require("lazy").setup(spec, {
  defaults = {
    -- cond skips loading while retaining installed plugins and their lock entries.
    cond = function(plugin)
      return not vim.g.vscode or vscode_plugins[plugin.name] == true
    end,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
