-- This file is for plugins need no configuration.

local M = {
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}

return M
