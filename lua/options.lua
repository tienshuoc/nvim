vim.opt.clipboard = 'unnamedplus'   -- use system clipboard 
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

----------------------------------- Indentation -----------------------------------
vim.opt.tabstop = 4                 -- Tab size is equal to 4 spaces.
vim.opt.softtabstop = 4             -- Indent using 4 spaces.
vim.opt.shiftwidth = 4              -- When shifting, indent using 4 spaces.
vim.opt.expandtab = true            -- Convert tabs to spaces.
vim.opt.smarttab = true             -- "Insert "tabstop" number of spaces when the "tab" key is pressed
vim.opt.autoindent = true           -- New lines inherit the indentation of previous lines.

-------------------------------------- Editing --------------------------------------
-- Disable automcommenting on newline.
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

-- Underline when in insert mode.
vim.cmd('au InsertEnter * set cul')
vim.cmd('au InsertLeave * set nocul')

-- Allow backspacing over indentation, line breaks, and insertion start.
vim.opt.backspace = 'indent,eol,start'

------------------------------------- Search Options ------------------------------
vim.opt.hlsearch = true              -- Enable search highlighting.
vim.opt.ignorecase = true            -- Ignore case when searching.
vim.opt.incsearch = true             -- Incremental search that shows partial matches.
vim.opt.smartcase = true             -- Automatiaclly switch search to case-sensitive when search query contains uppercase.
vim.cmd('set shortmess-=S')          -- Show search match counts.

------------------------------- Text Rendering Options ----------------------------
vim.opt.encoding = 'utf-8'
vim.opt.linebreak = true             -- Avoid wrapping a line in the middle of a word.
vim.opt.scrolloff = 10               -- The number of screen lines to keep above and below the cursor (a large value causes the cursor to stay in the middle line when possible.

------------------------------- User Interface Options ----------------------------
vim.opt.mouse = 'a'                  -- Enable mouse for scrolling and resizing.
vim.opt.laststatus = 2               -- Always display the status bar.
vim.opt.ruler = true                 -- Always show cursor position in status bar.
vim.opt.relativenumber = true
vim.opt.number = true

------------------------------- Miscellaneous Options -----------------------------
vim.opt.history = 1000               -- Increase the undo limit.
    



