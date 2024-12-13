return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      defaults = {
        file_ignore_patterns = { "%.git/", ".venv/", "node_modules/" },
      },
    })

    telescope.load_extension("live_grep_args")
    -- local live_grep_args = require("telescope").extensions.live_grep_args

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sr", builtin.live_grep, { desc = "[S]earch live_[R]ipgrep" })
    vim.keymap.set("n", "<leader>sg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "[S]earch live_[G]rep" })
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })
  end,
}
