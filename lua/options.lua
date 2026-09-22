-- Native OSC52 clipboard support for SSH/tmux (Neovim 10.0+)
local function paste()
  local lines = vim.fn.getreg("", 1, true)
  -- Clipboard providers accept one type character, without a block width.
  local regtype = vim.fn.getregtype(""):sub(1, 1)
  if regtype == "V" or regtype == "\22" then
    -- Match the trailing newline in Neovim's clipboard provider format.
    lines[#lines + 1] = ""
  end
  return { lines, regtype }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    -- Uses OSC52 to send to system clipboard.
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    -- Just reads from Neovim's internal register instead of querying the terminal.
    ["+"] = paste,
    ["*"] = paste,
  },
}

vim.opt.clipboard = "unnamedplus" -- Use system clipboard via OSC52
vim.opt.completeopt = { "menu", "menuone", "noselect" }

----------------------------------- Indentation -----------------------------------
vim.opt.tabstop = 4 -- Tab size is equal to 4 spaces.
vim.opt.softtabstop = 4 -- Indent using 4 spaces.
vim.opt.shiftwidth = 4 -- When shifting, indent using 4 spaces.
vim.opt.expandtab = true -- Convert tabs to spaces.
vim.opt.smarttab = true -- "Insert "tabstop" number of spaces when the "tab" key is pressed
vim.opt.autoindent = true -- New lines inherit the indentation of previous lines.

-------------------------------------- Editing --------------------------------------
-- Disable automatic comment formatting and continuation.
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
  callback = function(ev)
    -- Apply after filetype plugins have set their buffer-local defaults.
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.bo[ev.buf].formatoptions = vim.bo[ev.buf].formatoptions:gsub("[cro]", "")
      end
    end)
  end,
})

-- Highlight the cursor line in Insert/Replace modes; Ctrl-C skips InsertLeave.
vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("insert_cursorline", { clear = true }),
  pattern = { "*:[iR]*", "[iR]*:*" },
  callback = function()
    vim.opt_local.cursorline = vim.v.event.new_mode:match("^[iR]") ~= nil
  end,
})

-- Disable swap before Neovim checks for existing swaps on these files.
local no_swap_group = vim.api.nvim_create_augroup("no_swap_files", { clear = true })
vim.api.nvim_create_autocmd({ "BufNew", "BufReadPre", "BufNewFile" }, {
  group = no_swap_group,
  pattern = { "*.log", "*.mlir", "*.log.gz" },
  callback = function(ev)
    vim.bo[ev.buf].swapfile = false
  end,
})
-- Command-line buffers can exist before this module loads.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  vim.api.nvim_exec_autocmds("BufNew", { group = no_swap_group, buffer = buf, modeline = false })
end

-- Allow backspacing over indentation, line breaks, and insertion start.
vim.opt.backspace = "indent,eol,start"

------------------------------------- Search Options ------------------------------
vim.opt.hlsearch = true -- Enable search highlighting.
vim.opt.ignorecase = true -- Ignore case when searching.
vim.opt.incsearch = true -- Incremental search that shows partial matches.
vim.opt.smartcase = true -- Automatically switch search to case-sensitive when search query contains uppercase

------------------------------- Text Rendering Options ----------------------------
vim.opt.linebreak = true -- Avoid wrapping a line in the middle of a word.
vim.opt.wrap = false -- Don't wrap by default.
------------------------------- User Interface Options ----------------------------
vim.opt.mouse = "a" -- Enable mouse for scrolling and resizing.
vim.opt.laststatus = 2 -- Always display the status bar.
vim.opt.ruler = true -- Always show cursor position in status bar.
vim.opt.relativenumber = false
vim.opt.number = true
vim.opt.termguicolors = true -- Enables 24-bit RGB color in the terminal UI.
vim.opt.pumblend = 25 -- Enables pseudo-transparency for the popup menu.

------------------------------- Miscellaneous Options -----------------------------
vim.opt.history = 1000 -- Number of command-line and search history entries to remember.
vim.opt.updatetime = 500 -- Idle ms before writing the swap file and firing CursorHold (gitsigns, LSP, etc.).

-- Disable unused providers for faster startup
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
