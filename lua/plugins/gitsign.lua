local M = {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      attach_to_untracked = true,
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        ---@param mode string
        ---@param l string
        ---@param r string|fun():nil
        ---@param opts? table
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map("n", "<leader>ga", gs.stage_hunk, { desc = "[G]it [A]dd" })
        map("v", "<leader>ga", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "[G]it [A]dd (selected)" })

        map("n", "<leader>gr", gs.reset_hunk, { desc = "[G]it [R]estore" })
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "[G]it [R]estore (selected)" })

        map("n", "<leader>gA", gs.stage_buffer, { desc = "[G]it [A]dd (all)" })
        map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "[G]it [U]ndo" })
        map("n", "<leader>gp", gs.preview_hunk, { desc = "[G]it [P]review hunk diff" })
        map("n", "<leader>gd", gs.diffthis, { desc = "[G]it [D]iff" })
      end,
    })
  end,
}

return M
