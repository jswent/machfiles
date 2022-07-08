-- Additional filetypes that must be autodetected

vim.cmd [[
  
  "rofi configuration files 
  au BufRead,BufNewFile *.rasi set filetype=rofi
  
  ".aliases, .bash_aliases, etc.
  au BufRead,BufNewFile .*aliases set filetype=sh
]]
