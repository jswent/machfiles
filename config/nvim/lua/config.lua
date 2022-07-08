vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.scrolloff = 5
vim.opt.fileencoding = 'utf-8'
vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.showmode = false
vim.opt.showtabline = 2

--set default notify function
vim.notify = require('notify')

-- set color of fillchars to blankss
-- vim.wo.fillchars='eob: '
vim.cmd[[set fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:‾]]

-- enable mouse use
vim.cmd[[set mouse=a]]

-- set global statusline
vim.cmd[[set laststatus=3]]

vim.g.nord_contrast = true
vim.g.nord_borders = true
vim.g.nord_disable_background = false
vim.g.nord_italic = false

-- Load the colorscheme
local theme = os.getenv("NVIM_THEME") 
if(theme == "nord") then
  require('nord').set() 
elseif(theme == "nightfox") then
  require('config.nightfox') 
else 
  vim.cmd[[colorscheme custom]]
end
