vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.completeopt = { "menu", "menuone", "noselect" }

----------------------------------- Indentation -----------------------------------
vim.opt.tabstop = 4 -- Tab size is equal to 4 spaces.
vim.opt.softtabstop = 4 -- Indent using 4 spaces.
vim.opt.shiftwidth = 4 -- When shifting, indent using 4 spaces.
vim.opt.expandtab = true -- Convert tabs to spaces.
vim.opt.smarttab = true -- "Insert "tabstop" number of spaces when the "tab" key is pressed
vim.opt.autoindent = true -- New lines inherit the indentation of previous lines.

-------------------------------------- Editing --------------------------------------
-- Disable automcommenting on newline.
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

-- Underline when in insert mode.
vim.cmd("au InsertEnter * set cul")
vim.cmd("au InsertLeave * set nocul")

-- Allow backspacing over indentation, line breaks, and insertion start.
vim.opt.backspace = "indent,eol,start"

------------------------------------- Search Options ------------------------------
vim.opt.hlsearch = true -- Enable search highlighting.
vim.opt.ignorecase = true -- Ignore case when searching.
vim.opt.incsearch = true -- Incremental search that shows partial matches.
vim.opt.smartcase = true -- Automatiaclly switch search to case-sensitive when search query contains uppercase.
vim.opt.shortmess:append({S = true}) -- Don't show search match counts. Rely on lualine plugin s/t display in a file-by-file window and don't have a max limit.

------------------------------- Text Rendering Options ----------------------------
vim.opt.encoding = "utf-8"
vim.opt.linebreak = true -- Avoid wrapping a line in the middle of a word.
vim.opt.scrolloff = 5 -- The number of screen lines to keep above and below the cursor unless hitting EOF (a large value causes the cursor to stay in the middle line when possible.
vim.opt.wrap = false -- Don't wrap by default.

------------------------------- User Interface Options ----------------------------
vim.opt.mouse = "a" -- Enable mouse for scrolling and resizing.
vim.opt.laststatus = 2 -- Always display the status bar.
vim.opt.ruler = true -- Always show cursor position in status bar.
vim.opt.relativenumber = false
vim.opt.number = true
vim.opt.termguicolors = true -- Enables 24-bit RGB color in the terminal UI.
vim.opt.pumblend = 25 -- Enables pseudo-transparency for the popup menu.

------------------------------- Highlight Groups ----------------------------
vim.api.nvim_set_hl(0, "VirtualTextWarning", { fg = "#e7c664" })
vim.api.nvim_set_hl(0, "VirtualTextError", { fg = "#fc5d7c" })

------------------------------- Miscellaneous Options -----------------------------
vim.opt.history = 1000 -- Increase the undo limit.
vim.opt.updatetime = 50 -- If this many milliseconds nothing is styped, the swap file will be written to disk.
