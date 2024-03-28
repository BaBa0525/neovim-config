vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) test",
  group = vim.api.nvim_create_augroup("baba-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
