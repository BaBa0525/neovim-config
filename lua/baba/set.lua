vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.clipboard = "unnamedplus"

-- Save undo history
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.showmode = false

vim.diagnostic.config({
  -- severity = { min = vim.diagnostic.severity.INFO },
  virtual_text = {
    severity = { min = vim.diagnostic.severity.INFO },
  },
})

vim.api.nvim_set_var("c_syntax_for_h", 1)

vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
})
