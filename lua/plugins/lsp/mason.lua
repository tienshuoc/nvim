-- Package manager for LSP servers, DAP servers, linters, and formatters.
return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	opts = {
		ensure_installed = {
			"lua-language-server",
			"stylua",
			"clangd",
			"clang-format",
		},
	},
}
