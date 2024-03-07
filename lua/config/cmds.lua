local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-------------------------------------- cmd ------------------------------------------

vim.cmd [[ abbr reutrn return ]]

-------------------------------------- autocmds ------------------------------------------
-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+://" then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})


-------------------------------------- usercmds ------------------------------------------
vim.api.nvim_create_user_command("MasonInstallAll", function()
  if opts.ensure_installed and #opts.ensure_installed > 0 then
    vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
  end
end, {})
