local Shade = require("nightfox.lib.shade")

-- Default options
require('nightfox').setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = true,    -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,   -- Non focused panes set to alternative background
    styles = {              -- Style to be applied to different syntax groups
      comments = "NONE",    -- Value is any valid attr-list value `:help attr-list`
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = {             -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = {             -- List of various plugins and additional options
      cmp = true,
      notify = true,
      nvimtree = true,
      telescope = true,
      treesitter = true,
      whichkey = true,
    },
    palettes = {
      nightfox = {
        black   = Shade.new("#393b44", 0.15, -0.15),
        red     = Shade.new("#c94f6d", 0.15, -0.15),
        green   = Shade.new("#81b29a", 0.10, -0.15),
        yellow  = Shade.new("#dbc074", 0.15, -0.15),
        blue    = Shade.new("#23a9d5", 0.15, -0.15),
        magenta = Shade.new("#9d79d6", 0.30, -0.15),
        cyan    = Shade.new("#63cdcf", 0.15, -0.15),
        white   = Shade.new("#dfdfe0", 0.15, -0.15),
        orange  = Shade.new("#f4a261", 0.15, -0.15),
        pink    = Shade.new("#d67ad2", 0.15, -0.15),

        comment = "#738091",

        bg0     = "#9b2028", -- Dark bg (status line and float)
        bg1     = "#192330", -- Default bg
        bg2     = "#212e3f", -- Lighter bg (colorcolm folds)
        bg3     = "#29394f", -- Lighter bg (cursor line)
        bg4     = "#39506d", -- Conceal, border fg

        fg0     = "#d6d6d7", -- Lighter fg
        fg1     = "#cdcecf", -- Default fg
        fg2     = "#aeafb0", -- Darker fg (status line)
        fg3     = "#71839b", -- Darker fg (line numbers, fold colums)

        sel0    = "#2b3b51", -- Popup bg, visual selection bg
        sel1    = "#3c5372", -- Popup sel bg, search bg
      },
    },
    specs = {
      all = {
        syntax = {
          builtin0  = "magenta",       -- Builtin variable
          builtin3  = "blue.bright",
          keyword   = "blue",
          comment   = "blue",
        },
      },
    },
    groups = {
      WhichKeyDesc   = { fg = "blue" },
      WhichKeyGroup  = { fg = "blue.bright" },
    },
  }
})

local override = require('nightfox').override 

override.palettes({
  nightfox = {
    --blue = "#23a9d5",
  },
})

override.specs({
  nightfox = {
    syntax = {
      keyword = "blue.bright"
    }
  }
})

override.groups({
  all = {
    --WhichKeyDesc = { fg = "#23a9d5" }
  }
})

-- setup must be called before loading
vim.cmd("colorscheme nightfox")
