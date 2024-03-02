local M = {
	-- Conllection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		-- - va)	- [V]isually select [A]round [)]parenthen
		-- - yinq	- [Y]ank [I]nside [N]ext [']quote
		-- - ci'	- [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Simple and easy statusline.
		local statusline = require("mini.statusline")
		statusline.setup()

		-- You can configure sections in the statusline by overriding their
		-- default behavior. For example, here we disable the section for
		-- cursor information because line numbers are already enabled
		statusline.section_location = function()
			return ""
		end
	end,
}

return M
