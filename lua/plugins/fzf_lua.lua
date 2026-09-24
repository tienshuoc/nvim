return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", "<cmd> FzfLua files<cr>", mode = "n", noremap = true, desc = "Fuzzy search files." },
    {
      "<leader>fg",
      "<cmd> FzfLua live_grep<cr>",
      mode = "n",
      noremap = true,
      desc = "Live grep current project with glob support.",
    },
    {
      "<leader>fb",
      "<cmd> FzfLua buffers<cr>", -- Default already sorts by most-recently-used.
      mode = "n",
      noremap = true,
      desc = "Search buffers.",
    },
    {
      "<leader>ss",
      "<cmd> FzfLua lsp_document_symbols<cr>",
      mode = "n",
      noremap = true,
      desc = "Search document symbols.",
    },
    {
      "<leader>ft",
      "<cmd> FzfLua treesitter<cr>",
      mode = "n",
      noremap = true,
      desc = "Fuzzy search treesitter components.",
    },
    {
      "<leader>fh",
      "<cmd> FzfLua helptags<cr>",
      mode = "n",
      noremap = true,
      desc = "Search help documentation.",
    },
    {
      "<leader>fj",
      "<cmd> FzfLua jumps<cr>",
      mode = "n",
      noremap = true,
      desc = "Fuzzy search jumps.",
    },
    {
      "<leader>fm",
      "<cmd> FzfLua marks<cr>",
      mode = "n",
      noremap = true,
      desc = "Fuzzy search marks.",
    },
    {
      "<leader>fn",
      "<cmd> FzfLua builtin<cr>",
      mode = "n",
      noremap = true,
      desc = "Fuzzy search builtin commands.",
    },
    {
      "<leader>fd",
      "<cmd> FzfLua commands<cr>",
      mode = "n",
      noremap = true,
      desc = "Fuzzy search commands.",
    },
    {
      "<leader>sh",
      "<cmd> FzfLua search_history<cr>",
      mode = "n",
      noremap = true,
      desc = "Fuzzy search search-history.",
    },
    {
      "<leader>fl",
      "<cmd>lua FzfLua.grep({resume=true})<cr>",
      mode = "n",
      noremap = true,
      desc = "Fuzzy find last search.",
    },
    {
      "<leader>fr",
      "<cmd> FzfLua registers<cr>",
      mode = "n",
      noremap = true,
      desc = "Fuzzy search registers.",
    },
  },
  opts = {
    "fzf-vim", -- Give fzf-vim-like keymaps and feel.
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
    winopts = {
      width = 0.7,
      height = 0.5,
      row = 0.85, -- window row position (0=top, 1=bottom)
      col = 0.50, -- window col position (0=left, 1=right)
      backdrop = 40, -- (what's outside the preview window) 0 is opaque, 100 is transparent
      preview = {
        hidden = false,
        horizontal = "right:50%",
        flip_columns = 120,
        delay = 0,
      },
    },
    fzf_opts = {
      ["--cycle"] = "", -- Cycles back from last result to the first when scrolling.
      ["--layout"] = "reverse", -- Reverses the search bar to be on top.
    },
    lsp = {
      -- Native single-result jumps preserve LSP position encodings.
      -- Upstream multi-result picker jumps can still misplace Unicode columns.
      jump1_action = false,
    },
    files = {
      -- v2 retains a hidden original path for matching behind the filename-first display.
      formatter = { "path.filename_first", 2 },
    },
  },
}
