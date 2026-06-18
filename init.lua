-------- README --------
-- options.lua       : global options
-- keymaps.lua       : keymappings
-- lazy_manager.lua  : plugin manager + which plugins load per environment
-- sessions.lua      : session management
-- vscode_config.lua : config used when running inside the VSCode Neovim extension
-- lua/plugins/      : plugin specs (incl. lsp/, git/, dbg/)
--____________________

--- Map Leader ---
vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
  require("vscode_config")
else
  -- Set up large file detection for both startup and runtime
  require("utils.handle_large_file").setup()

  require("lazy_manager") -- This will set up and load all plugins
  require("options") -- Load default options first and override if large file in large file settings below.
  require("keymaps")
  require("utils.auto_hlsearch").setup() -- Auto-toggle hlsearch on search keys
  require("sessions").setup() -- Set up session management keymaps
end
