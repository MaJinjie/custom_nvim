vim.ctx = vim.ctx or {}
vim.ctx.path = vim.ctx.path or {}

local nvim_path = vim.fn.expand "$XDG_CONFIG_HOME" .. "/nvim"
local path = vim.ctx.path

path = {
  snippets = nvim_path .. "/snippets",
}
