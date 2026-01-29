-------- README --------
-- colorscheme.lua : theme
-- keymaps.lua     : keymappings
-- lsp.lua         : LSP support
-- options.lua     : global options
-- plugins.lua     : third-party plugins
--____________________

--- Map Leader ---
vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
  local vscode = require("vscode")
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
  vim.keymap.set("n", "<leader>w", ":w<CR>", vim.tbl_extend("force", opts, { desc = "Write file." }))
  vim.keymap.set({ "n", "v" }, "<leader>qq", function()
    vscode.action("workbench.action.closeActiveEditor")
  end, vim.tbl_extend("force", opts, { desc = "Quit file." }))

  vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
  vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

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
  vim.opt.smartcase = true -- Automatiaclly switch search to case-sensitive when search query contains uppercase.
  vim.opt.ignorecase = true -- Ignore case when searching.

  -- Disable session history tracking in VSCode to avoid concurrent write conflicts with the one running in terminal.
  vim.opt.shada = ""

  -- Cursor centering
  vim.keymap.set(
    "n",
    "zZ",
    "zszH",
    vim.tbl_extend("force", opts, { desc = "Center cursor on middle of screen horizontal." })
  )

  vim.keymap.set("c", "<CR>", function()
    return vim.fn.getcmdtype() == "/" and "<CR>zzzv" or "<CR>"
  end, {
    noremap = true,
    expr = true,
    desc = "Center first search result",
  })

  vim.keymap.set(
    "n",
    "n",
    "nzzzv",
    vim.tbl_extend("force", opts, { desc = "Keeps next search term in middle of screen." })
  )
  vim.keymap.set(
    "n",
    "N",
    "Nzzzv",
    vim.tbl_extend("force", opts, { desc = "Keeps previous search term in middle of screen." })
  )
  vim.keymap.set("n", "G", "Gzz", vim.tbl_extend("force", opts, { desc = "Keeps goto line in middle of screen." }))
  require("lazy_manager")

  -- Plugins
else
  -- Set up large file detection for both startup and runtime
  require("utils.handle_large_file").setup()

  require("lazy_manager") -- This will set up and load all plugins
  require("options") -- Load default options first and override if large file in large file settings below.
  require("keymaps")
  require("sessions").setup() -- Set up session management keymaps

  if vim.g.is_large_file_on_startup then
    -- Mark the buffer as already checked to prevent duplicate handling by autocommand
    vim.b.large_file_checked = true
    vim.b.large_file = true
    require("utils.handle_large_file").apply_large_file_settings()
  end
end
