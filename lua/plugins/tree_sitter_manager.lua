return {
  -- Requires:
  --  * Neovim 0.12+
  --  * tree-sitter CLI
  "romus204/tree-sitter-manager.nvim",
  opts = {
    languages = {
      -- Not in tree-sitter-manager's registry; needed by markview.nvim for
      -- `.adoc` previews. Both grammars live in the same repo.
      --
      -- Pinned: upstream commit d01171b (2026-06-15) renamed the `attr_value`
      -- node to `attribute_value`, which makes markview's asciidoc query fail
      -- to parse. markview then silently renders nothing. dd0d426 is the last
      -- revision before that rename. Unpin once markview updates its query.
      asciidoc = {
        install_info = {
          url = "https://github.com/cathaysia/tree-sitter-asciidoc",
          revision = "dd0d4262fd0a7b2e99fd795a7f6b47190ab15eb2",
          location = "tree-sitter-asciidoc",
          queries = "queries",
          use_repo_queries = true,
        },
        requires = { "asciidoc_inline" },
      },
      asciidoc_inline = {
        install_info = {
          url = "https://github.com/cathaysia/tree-sitter-asciidoc",
          revision = "dd0d4262fd0a7b2e99fd795a7f6b47190ab15eb2",
          location = "tree-sitter-asciidoc_inline",
          queries = "queries",
          use_repo_queries = true,
        },
      },
    },
    ensure_installed = {
      "asciidoc",
      "asciidoc_inline",
      "c",
      "cpp",
      "bash",
      "lua",
      "python",
      "diff",
      "dockerfile",
      "doxygen",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "html",
      "jsonnet",
      "llvm",
      "mlir",
      "markdown",
      "markdown_inline",
      "regex",
      "rust",
      "tablegen",
      "vimdoc",
      "vim",
    },
  },
}
