return {
  "lmantw/themify.nvim",

  lazy = false,
  priority = 999,
  cond = function()
    -- Don't load themify for large files
    return not vim.g.is_large_file_on_startup
  end,
  dependencies = { "ibhagwan/fzf-lua" },
  keys = {
    {
      "<leader>T",
      mode = { "n" },
      function()
        vim.cmd("Themify")
      end,
      desc = "Toggle Themify.",
    },
    {
      "<leader>fc",
      mode = { "n" },
      function()
        require("plugins.themify").fzf_colorscheme_picker()
      end,
      desc = "Fuzzy search colorschemes with live preview and persistence.",
    },
  },

  config = function()
    require("themify").setup({
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
    })
  end,

  -- FzfLua colorscheme picker with live preview
  fzf_colorscheme_picker = function()
    local fzf = require("fzf-lua")
    local shell = require("fzf-lua.shell")
    local themify = require("themify.api")
    local manager = require("themify.core.manager")

    -- Check if Manager is available
    if not themify.Manager or not themify.Manager.colorschemes then
      vim.notify("Themify Manager not initialized yet", vim.log.levels.ERROR)
      return
    end

    -- Save current colorscheme to restore on cancel
    local original = themify.get_current()
    local live_preview = nil
    local selection_made = false

    -- Build list of colorscheme entries
    local entries = {}
    local entry_map = {}

    for _, colorscheme_id in ipairs(themify.Manager.colorschemes) do
      local colorscheme_data = themify.Manager.get(colorscheme_id)

      if colorscheme_data and colorscheme_data.themes then
        for _, theme in ipairs(colorscheme_data.themes) do
          local display = string.format("%s", theme)
          table.insert(entries, display)
          entry_map[display] = { colorscheme_id = colorscheme_id, theme = theme }
        end
      else
        local display = colorscheme_id
        table.insert(entries, display)
        entry_map[display] = { colorscheme_id = colorscheme_id, theme = nil }
      end
    end

    if #entries == 0 then
      vim.notify("No colorschemes found in Themify", vim.log.levels.WARN)
      return
    end

    -- Find current colorscheme index to start picker there
    local current = themify.get_current()
    local cursor_idx = 1
    for i, entry in ipairs(entries) do
      local info = entry_map[entry]
      if info then
        local colorscheme_match = (info.theme and info.theme == current.colorscheme_id)
          or (not info.theme and info.colorscheme_id == current.colorscheme_id)
        local theme_match = info.theme == current.theme or current.theme == nil
        if colorscheme_match and theme_match then
          cursor_idx = i
          break
        end
      end
    end

    -- Show FzfLua picker with live preview
    fzf.fzf_exec(entries, {
      prompt = "Colorschemes> ",
      fzf_opts = {
        ["--preview-window"] = "nohidden:right:0",
      },
      winopts = {
        backdrop = 100, -- Disables dimming background outside of the preview window.
        width = 0.25,
        on_close = function()
          if not selection_made and live_preview and original then
            themify.set_current(original.colorscheme_id, original.theme)
          end
        end,
      },
      keymap = {
        fzf = {
          start = "pos(" .. cursor_idx .. ")",
        },
      },
      preview = shell.stringify_data(function(sel)
        if sel and #sel > 0 then
          local entry = entry_map[sel[1]]
          if entry then
            live_preview = sel[1]
            manager.load_theme(entry.colorscheme_id, entry.theme)
          end
        end
      end, {}, "{}"),
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then
            return
          end

          selection_made = true
          local entry = entry_map[selected[1]]
          if entry then
            themify.set_current(entry.colorscheme_id, entry.theme)
            vim.notify(string.format("Applied: %s", selected[1]), vim.log.levels.INFO)
          end
        end,
      },
    })
  end,
}
