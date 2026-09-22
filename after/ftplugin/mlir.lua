vim.opt_local.modifiable = false
vim.opt_local.wrap = false

-- Restore defaults when this buffer changes filetype.
local undo = "setlocal modifiable< wrap<"
vim.b.undo_ftplugin = vim.b.undo_ftplugin and (vim.b.undo_ftplugin .. " | " .. undo) or undo
