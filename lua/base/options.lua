local opt = vim.opt
local g = vim.g

-------------------------------------- options ------------------------------------------
opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.inccommand = "split" -- preview incremental substitute

opt.termguicolors = true
opt.undofile = true
opt.undolevels = 10000

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250
opt.timeoutlen = 300
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

opt.scrolloff = 8
opt.sidescrolloff = 8 -- Columns of context
opt.guifont = "Hack Nerd Font,JetBrainsMono Nerd Font:h13"
opt.swapfile = false

opt.foldcolumn = "1" -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-------------------------------------- globals -----------------------------------------

-- custom path
-- g.path = g.path or {}
-- g.path.mason = vim.fn.stdpath "config" .. "/local/mason"
-- g.path.treesitter = vim.fn.stdpath "config" .. "/local/treesitter"

g.mapleader = " "

if g.neovide then
  g.neovide_transparency = 0.85
  -- 键入时隐藏鼠标
  g.neovide_hide_mouse_when_typing = true
  -- 和系统主题同步
  g.neovide_theme = "auto"
  -- 设置应用程序的刷新频率
  g.neovide_refresh_rate = 60
  -- 设置不再焦点时的刷新频率
  g.neovide_refresh_rate_idle = 5
  -- false强制始终绘制，这可能和上一个选项相反
  g.neovide_no_idle = true
  -- 未保持的更改时退出需要确认
  g.neovide_confirm_quit = true
  -- 设置应用程序是否占据整个屏幕
  g.neovide_fullscreen = true
  -- 是否记住上一次窗口大小
  g.neovide_remember_window_size = true
  -- 设置光标完成动画所需时间，0表示禁用
  -- g.neovide_cursor_animation_length = 0
  -- 启用抗锯齿
  g.neovide_cursor_antialiasing = true
  -- 如果为false,命令模式和编辑模式的切换 不设置动画
  g.neovide_cursor_animate_command_line = false
end
