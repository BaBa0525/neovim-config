local M = {
  "folke/which-key.nvim",
  event = "VimEnter",
  config = function()
    require("which-key").setup()

    -- Document existing key chains
    require("which-key").add({
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ocument" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>w", group = "[W]orkspace" },
    })
  end,
}

return M
