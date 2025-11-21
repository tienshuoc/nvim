return {
  "ibhagwan/fzf-lua",
  lazy = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ff", "<cmd> FzfLua files<cr>", mode = "n", { noremap = true, desc = "Fuzzy search files." } },
    {
      "<leader>fg",
      "<cmd> FzfLua live_grep<cr>",
      mode = "n",
      { noremap = true, desc = "Live grep current project with glob support." },
    },
    {
      "<leader>ss",
      "<cmd> FzfLua lsp_document_symbols<cr>",
      mode = "n",
      { noremap = true, desc = "Search document symbols." },
    },
    {
      "<leader>ft",
      "<cmd> FzfLua treesitter<cr>",
      mode = "n",
      { noremap = true, desc = "Fuzzy search treesitter components." },
    },
    {
      "<leader>fh",
      "<cmd> FzfLua helptags<cr>",
      mode = "n",
      { noremap = true, desc = "Search help documentation." },
    },
    {
      "<leader>fc",
      "<cmd> FzfLua colorschemes<cr>",
      mode = "n",
      { noremap = true, desc = "Fuzzy search and apply colorschemes." },
    },
    {
      "<leader>fj",
      "<cmd> FzfLua jumps<cr>",
      mode = "n",
      { noremap = true, desc = "Fuzzy search jumps." },
    },
    {
      "<leader>fm",
      "<cmd> FzfLua marks<cr>",
      mode = "n",
      { noremap = true, desc = "Fuzzy search marks." },
    },
    {
      "<leader>fn",
      "<cmd> FzfLua builtin<cr>",
      mode = "n",
      { noremap = true, desc = "Fuzzy search builtin commands." },
    },
    {
      "<leader>fd",
      "<cmd> FzfLua commands<cr>",
      mode = "n",
      { noremap = true, desc = "Fuzzy search commands." },
    },
    {
      "<leader>sh",
      "<cmd> FzfLua search_history<cr>",
      mode = "n",
      { noremap = true, desc = "Fuzzy search search-history." },
    },
    {
      "<leader>fl",
      "<cmd>lua FzfLua.grep({resume=true})<cr>",
      mode = "n",
      { noremap = true, desc = "Fuzzy find last search." },
    },
    {
      "<leader>fr",
      "<cmd> FzfLua registers<cr>",
      mode = "n",
      { noremap = true, desc = "Fzzy search registers." },
    },
  },
  config = function()
    require("fzf-lua").setup({
      "fzf-vim", -- Give fzf-vim-like keymaps and feel.
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
      winopts = {
        width = 0.8,
        height = 0.9,
        preview = {
          hidden = "nohidden",
          vertical = "up:45%",
          horizontal = "right:50%",
          layout = "flex",
          flip_columns = 120,
          delay = 10,
          winopts = { number = false },
        },
      },
      fzf_opts = { ["--cycle"] = "" }, -- Cycles back from last result to the first when scrolling.
      cmd = "fd", -- Favour using `fd` first.
      files = {
        -- Uses v2 version of filename_first.
        -- Issue with just doing "path.filename_first" is that it matches on how the string itself is presented to the user.
        -- So instead of fuzzy finding `path` + `filename`, it fuzzy finds on `filename` + `path`.
        -- See: https://www.reddit.com/r/neovim/comments/1dck9r3/fzflua_pathfilename_first_causing_issues_with/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        formatter = { "path.filename_first", 2 },
      },
    })
  end,
}
