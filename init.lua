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
  local size_limit = 10 * 1024 * 1024 -- 10MB
  local file_to_check = vim.fn.argv()[1] -- Get the first file argument from the command line
  vim.g.is_large_file_on_startup = false

  -- Check if a file was passed on startup and if it's large
  if file_to_check and vim.fn.filereadable(vim.fn.expand(file_to_check)) == 1 then
    if vim.fn.getfsize(file_to_check) > size_limit then
      vim.g.is_large_file_on_startup = true
    else
    end
  end

  -- Set up the autocommand to handle large files opened *during* this session.
  local large_file_group = vim.api.nvim_create_augroup("LargeFileHandler", { clear = true })
  vim.api.nvim_create_autocmd("BufNew", {
    group = large_file_group,
    pattern = "*",
    callback = function()
      local buf_path = vim.api.nvim_buf_get_name(0)
      if buf_path == "" then
        return
      end

      -- this is buggy when doing cdo on quickfix list
      local file_path = vim.fn.fnamemodify(buf_path, ":p")
      local stat = vim.loop.fs_stat(file_path)

      if stat and stat.size > size_limit then
        require("utils.handle_large_file").apply_large_file_settings()
      end
    end,
  })

  require("lazy_manager") -- This will set up and load all plugins
  require("options") -- Load default options first and override if large file in large file settings below.
  require("keymaps")
  require("sn_options")

  if vim.g.is_large_file_on_startup then
    require("utils.handle_large_file").apply_large_file_settings()
  end
end
