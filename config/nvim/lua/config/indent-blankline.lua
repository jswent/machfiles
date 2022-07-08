return function()
  require("indent_blankline").setup({
    char = "|",
    show_end_of_line = true,
    disable_with_nolist = true,
    buftype_exclude = { "terminal" },
    filetype_exclude = { "packer", "alpha", "help", "git", "markdown", "snippets", "text", "gitconfig" },
  })

  vim.cmd([[
    function! Should_activate_indentblankline() abort
      if index(g:indent_blankline_filetype_exclude, &filetype) == -1
        IndentBlanklineEnable
      endif
    endfunction
    augroup indent_blankline
      autocmd!
      autocmd InsertEnter * IndentBlanklineDisable
      autocmd InsertLeave * call Should_activate_indentblankline()
    augroup END
  ]])
end
