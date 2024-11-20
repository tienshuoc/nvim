-- Note: Neovim 10.0+ supports OSC52 natively, there's no need for this plugin.
-- Shares a SSH vim's clipboard with local clipboard.
return {
  "ojroques/nvim-osc52",
  branch = main,
  lazy = false,
  config = function()
    local function copy(lines, _)
      require("osc52").copy(table.concat(lines, "\n"))
    end

    local function paste()
      return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    end

    vim.g.clipboard = {
      name = "osc52",
      copy = { ["+"] = copy, ["*"] = copy },
      paste = { ["+"] = paste, ["*"] = paste },
    }
  end,
}
