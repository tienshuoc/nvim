local function pick_colorscheme()
  local themify = require("themify.api")
  local manager = require("themify.core.manager")
  local original_theme = vim.g.colors_name or "default"
  local entries, entry_map = {}, {}
  local cursor_idx = 1

  for _, colorscheme_id in ipairs(themify.Manager.colorschemes) do
    local colorscheme = themify.Manager.get(colorscheme_id)
    local is_local = colorscheme.type == "local"
    for _, theme in ipairs(is_local and { colorscheme_id } or colorscheme.themes) do
      entries[#entries + 1] = theme
      -- Themify identifies built-in themes by (nil, theme).
      entry_map[theme] = { colorscheme_id = not is_local and colorscheme_id or nil, theme = theme }
      if theme == original_theme then
        cursor_idx = #entries
      end
    end
  end

  if #entries == 0 then
    vim.notify("No colorschemes found in Themify", vim.log.levels.WARN)
    return
  end

  local original, original_background, previewed
  require("fzf-lua").fzf_exec(entries, {
    prompt = "Colorschemes> ",
    fzf_opts = {
      ["--preview-window"] = "nohidden:right:0",
    },
    winopts = {
      backdrop = 100,
      width = 0.25,
      on_create = function()
        -- Also runs when fzf-lua resumes a hidden picker.
        original_theme = vim.g.colors_name or "default"
        original_background = vim.o.background
        original = entry_map[original_theme]
        previewed = false
      end,
      on_close = function()
        -- Fzf-lua closes the picker before running the selection action.
        if previewed then
          if original then
            manager.load_theme(original.colorscheme_id, original.theme)
          else
            vim.cmd.colorscheme(original_theme)
          end
          vim.o.background = original_background
          previewed = false
        end
      end,
    },
    keymap = {
      fzf = { start = "pos(" .. cursor_idx .. ")" },
    },
    preview = function(selected)
      local entry = selected and entry_map[selected[1]]
      if entry then
        previewed = true
        -- The internal loader runs theme hooks without persisting previews.
        manager.load_theme(entry.colorscheme_id, entry.theme)
      end
    end,
    actions = {
      ["default"] = function(selected)
        local entry = selected and entry_map[selected[1]]
        if entry then
          themify.set_current(entry.colorscheme_id, entry.theme)
          vim.notify(string.format("Applied: %s", entry.theme), vim.log.levels.INFO)
        end
      end,
    },
  })
end

return {
  "lmantw/themify.nvim",
  lazy = false,
  priority = 999,
  dependencies = { "ibhagwan/fzf-lua" },
  keys = {
    { "<leader>T", "<cmd>Themify<cr>", mode = "n", desc = "Toggle Themify." },
    {
      "<leader>fc",
      pick_colorscheme,
      mode = "n",
      desc = "Fuzzy search colorschemes with live preview and persistence.",
    },
  },
  opts = {
    async = false, -- Enabling this would load the colorscheme asynchronously, which might improve your startup time.
    -- Your list of colorschemes.
    -- Built-in colorschemes are also supported.
    -- (Also works with any colorschemes that are installed via other plugin manager, just make sure the colorscheme is loaded before Themify is loaded.)
    "default",
    "darkblue",
    "delek",
    "desert",
    "elflord",
    "evening",
    "industry",
    "koehler",
    "morning",
    "murphy",
    "pablo",
    "peachpuff",
    "ron",
    "shine",
    "slate",
    "torte",
    "zellner",
    -- { -- Disable cause currently themify doesn't support colorschemes with dependencies.
    --   "uloco/bluloco.nvim",
    --
    --   dependencies = { "rktjmp/lush.nvim" },
    -- },
    {
      "catppuccin/nvim", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
      before = function()
        -- The function run before the colorscheme is loaded.
        require("catppuccin").setup({
          transparent_background = false,
          dim_inactive = {
            enabled = false,
          },
        })
      end,
    },
    {
      "scottmckendry/cyberdream.nvim",
      before = function()
        require("cyberdream").setup({
          transparent = false,
          italic_comments = true,
        })
      end,
    },
    {
      "xiantang/darcula-dark.nvim",
    },
    {
      "Mofiqul/dracula.nvim", -- dracula, dracula-soft
      before = function()
        require("dracula").setup({
          transparent_bg = false,
        })
      end,
    },
    {
      "eldritch-theme/eldritch.nvim",
    },
    {
      "0xstepit/flow.nvim",
      before = function()
        require("flow").setup({})
      end,
    },
    {
      "savq/melange-nvim",
    },
    {
      "xero/miasma.nvim",
    },
    {
      "Mofiqul/vscode.nvim", -- vscode (:set background=dark/light)
      before = function()
        local c = require("vscode.colors").get_colors()
        require("vscode").setup({
          -- transparent = true,
          italic_comments = true,
          underline_links = true,
          -- Disable nvim-tree background color
          disable_nvimtree_bg = true,
          -- Override colors (see ./lua/vscode/colors.lua)
          color_overrides = {
            vscLineNumber = "#FFFFFF",
          },
          -- Override highlight groups (see ./lua/vscode/theme.lua)
          group_overrides = {
            Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
          },
        })
      end,
    },
    {
      "tanvirtin/monokai.nvim", -- monokai_pro
    },
    {
      "folke/tokyonight.nvim", -- tokyonight-night, tokyonight-storm, tokyonight-day, tokyonight-moon
    },
    {
      "sainnhe/sonokai",
      before = function()
        vim.g.sonokai_enable_italics = 1
        vim.g.sonokai_dim_inactive_windows = 1
        vim.g.sonokai_diagnostic_text_highlight = 1
        vim.g.sonokai_diagnostic_line_highlight = 1
        vim.g.sonokai_style = "default" -- 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
      end,
    },
    {
      "sainnhe/edge", -- Edge Dark (default, aura, neon), Edge Light
      before = function()
        vim.g.edge_dim_inactive_windows = 1
        vim.g.edge_enable_italic = 1
        vim.g.edge_style = "neon"
        -- vim.g.edge_transparent_background = 1
      end,
    },
    {
      "neanias/everforest-nvim",
      before = function()
        require("everforest").setup({
          -- transparent_background_level = 1,
        })
      end,
    },
    {
      "projekt0n/github-nvim-theme",
    },
    {
      "sainnhe/gruvbox-material",
      before = function()
        vim.g.gruvbox_material_dim_inactive_windows = 1
        vim.g.gruvbox_material_background = "soft" -- 'hard', 'medium', 'soft'
        vim.g.gruvbox_material_foreground = "material" -- 'material', 'mix', 'original'
        vim.g.gruvbox_material_statusline_style = "original" -- 'default', 'mix', 'original'
        vim.g.gruvbox_material_transparent_background = 0 -- 0, 1, 2 (statsline also transparent)
        vim.g.gruvbox_material_ui_contrast = "high" -- 'low', 'high' (contrast of line numbers, indent lines, etc)
        vim.g.gruvbox_material_enable_bold = 1
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_diagnostic_text_highlight = 1
        vim.o.background = "dark"
      end,
    },
    {
      "rebelot/kanagawa.nvim", -- kanagawa, kanagawa-wave, kanagawa-lotus, kanagawa-dragon
      before = function()
        require("kanagawa").setup({
          dimInactive = true,
        })
      end,
    },
    {
      "marko-cerovac/material.nvim", -- Oceanic, Deep Ocean, Palenight, Lighter, Darker
      before = function()
        vim.g.material_style = "Palenight"
      end,
    },
    {
      "miikanissi/modus-themes.nvim",
    },
    {
      "bluz71/vim-moonfly-colors",
    },
    {
      "EdenEast/nightfox.nvim", -- nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
    },
    {
      "navarasu/onedark.nvim", -- 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
      before = function()
        require("onedark").setup({
          style = "dark",
        })
      end,
    },
    {
      "sonph/onehalf", -- onehalflight, onehalfdark
      -- Has special rtp = "vim/" property, not sure if themify supports this
      rtp = "vim/",
    },
    {
      "NLKNguyen/papercolor-theme", -- PaperColor (:set background=dark/light)
    },
    {
      "rose-pine/neovim", -- rose-pine-main, rose-pine-dark, rise-pine-moon, rose-pine-dawn, rose-pine
      name = "rose-pine",
    },
    {
      "NTBBloodbath/sweetie.nvim",
    },
  },
}
