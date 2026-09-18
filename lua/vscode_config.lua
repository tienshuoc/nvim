-- Configuration for running inside the VSCode Neovim extension (vim.g.vscode).
-- Uses shared editor mappings alongside VS Code-specific actions and options.

local vscode = require("vscode")
require("keymaps_common")

-- Insert mode keybinding has to be done in `settings.json`:
-- "vscode-neovim.compositeKeys": {
--     "yy": {
--         "command": "vscode-neovim.escape",
--     },
-- },
local opts = {
  -- Define common options.
  noremap = true, -- non-recursive
  silent = true, -- do not show message
}
vim.keymap.set({ "n", "v" }, "<leader>qq", function()
  vscode.action("workbench.action.closeActiveEditor")
end, vim.tbl_extend("force", opts, { desc = "Quit file." }))

vim.keymap.set("n", "<leader>tt", function()
  vscode.action("workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup")
end, opts)
vim.keymap.set("n", "ff", function()
  vscode.action("workbench.action.quickOpen")
end, opts)
vim.keymap.set("n", "fg", function()
  vscode.action("workbench.action.findInFiles")
end, opts)
vim.keymap.set("n", "<leader>ss", function()
  vscode.action("workbench.action.gotoSymbol")
end, opts)
vim.keymap.set("n", "<leader>rn", function()
  vscode.action("editor.action.rename")
end, opts)
vim.keymap.set("n", "<leader>nt", function()
  vscode.action("workbench.action.toggleSidebarVisibility")
end, opts)

vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.smartcase = true -- Automatically switch search to case-sensitive when search query contains uppercase.
vim.opt.ignorecase = true -- Ignore case when searching.

-- Disable session history tracking in VSCode to avoid concurrent write conflicts with the one running in terminal.
vim.opt.shada = ""

require("lazy_manager")
