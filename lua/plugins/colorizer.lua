return {
  -- Display hex colors.
  "norcalli/nvim-colorizer.lua",
  event = "FileType",
  cmd = {
    "ColorizerAttachToBuffer",
    "ColorizerDetachFromBuffer",
    "ColorizerReloadAllBuffers",
    "ColorizerToggle",
  },
  -- This plugin's setup argument is a filetype list.
  opts = { "*" },
}
