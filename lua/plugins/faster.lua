return {
  "pteroctopus/faster.nvim",
  opts = {
    behaviors = {
      -- Behaviour can be turned on or off. To turn on set to true, otherwise
      -- set to false
      on = true,
      features_disabled = { "all" },
      -- Files larger than `filesize` are considered big files. Value is in MB.
      filesize = 2,
      -- Autocmd pattern that controls on which files behaviour will be applied.
      -- `*` means any file.
      pattern = "*",
    },
    features = {
      -- Neovim filetype plugin
      -- https://neovim.io/doc/user/filetype.html
      filetype = {
        on = true,
        defer = true,
      },
      -- Illuminate plugin
      -- https://github.com/RRethy/vim-illuminate
      illuminate = {
        on = true,
        defer = false,
      },
      -- Indent Blankline
      -- https://github.com/lukas-reineke/indent-blankline.nvim
      indent_blankline = {
        on = true,
        defer = false,
      },
      -- Neovim LSP
      -- https://neovim.io/doc/user/lsp.html
      lsp = {
        on = true,
        defer = false,
      },
      -- Lualine
      -- https://github.com/nvim-lualine/lualine.nvim
      lualine = {
        on = true,
        defer = false,
      },
      -- Neovim Pi_paren plugin
      -- https://neovim.io/doc/user/pi_paren.html
      matchparen = {
        on = true,
        defer = false,
      },
      -- Neovim syntax
      -- https://neovim.io/doc/user/syntax.html
      syntax = {
        on = true,
        defer = true,
      },
      -- Neovim treesitter
      -- https://neovim.io/doc/user/treesitter.html
      treesitter = {
        on = true,
        defer = false,
      },
      -- Neovim options that affect speed when big file is opened:
      -- swapfile, foldmethod, undolevels, undoreload, list
      vimopts = {
        on = true,
        defer = false,
      },
      gitsigns = {
        on = true,
        defer = true,
      },
      bufferline = {
        on = true,
        defer = true,
      },
    },
  },
}
