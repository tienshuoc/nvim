return {
  -- Dim unused functions, variables, parameters, and more. (Requires `-Wunused-variable` for clangd)
  "zbirenbaum/neodim",
  event = "LspAttach",
  opts = {
    hide = {
      -- Keep all decorations for 'unused' diagnostics.
      underline = false,
      virtual_text = false,
      signs = false,
    },
  },
}

-- For this to work with Clangd:
-- Either:
--     1. Specify `-Wunused-variable` in CMakeLists.txt.
--     2. Add in project root `.clangd`:
--        ```
--        CompileFlags:
--        Add: [-Wunused-variable]
--        ```
--     3. Add code snippet above in `$XDG_CONFIG_HOME/clangd/config.yaml` ( typically `~/.config/clangd/config.yaml`)
-- More information: https://clangd.llvm.org/config.html#files
