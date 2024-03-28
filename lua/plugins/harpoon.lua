local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    -- Required
    harpoon:setup({
      settings = {
        save_on_toggle = true,
      },
    })

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():append()
    end, { desc = "Add current file to harpoon" })

    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Open harpoon window" })

    vim.keymap.set("n", "<C-P>", function()
      harpoon:list():prev()
    end, { desc = "Go to previous in harpoon buffer" })

    vim.keymap.set("n", "<C-N>", function()
      harpoon:list():next()
    end, { desc = "Go to next in harpoon buffer" })
  end,
}

return M
