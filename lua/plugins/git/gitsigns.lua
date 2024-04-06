return {
	"lewis6991/gitsigns.nvim",
	ops = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
	},
	config = function()
		require("gitsigns").setup({
			current_line_blame = true,
			current_line_blame_opts = {
				delay = 0,
			},
		})
		vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>")
	end,
}
