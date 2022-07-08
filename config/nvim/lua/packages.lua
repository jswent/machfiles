-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packages.lua source <afile> | PackerSync
  augroup end
]]

require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use {'kyazdani42/nvim-web-devicons', event = 'VimEnter'}
  use { 'goolord/alpha-nvim', event = 'VimEnter', config = [[require('config.alpha-nvim')]] }

  use {
      'nvim-telescope/telescope.nvim',
      module = "telescope",
      requires = {{'nvim-lua/plenary.nvim'}},
      cmd = "Telescope",
      config = [[require('config.telescope')]]
  }
  use { "tom-anders/telescope-vim-bookmarks.nvim" }
  use { "nvim-telescope/telescope-media-files.nvim" }
  use { "nvim-telescope/telescope-ui-select.nvim" }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use { "nvim-telescope/telescope-project.nvim" }

  use {"folke/which-key.nvim",
  event = "VimEnter",
  config = function()
    vim.defer_fn(function() require('config.which-key') end, 2000)
  end
  }

  use { "windwp/nvim-autopairs",
    config = [[require('config.nvim-autopairs')]] 
  }

  use {"norcalli/nvim-colorizer.lua",
      config = [[require('config.colorizer')]]
  }

  if vim.g.is_win or vim.g.is_mac then
      -- open URL in browser
      use({"tyru/open-browser.vim", event = "VimEnter"})
    end

  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = [[require('config.nvim-tree')]]
  }

  use {"lunarvim/darkplus.nvim"}
  use 'shaunsingh/nord.nvim'
  use 'EdenEast/nightfox.nvim'  
  use {
    'xiyaowong/nvim-transparent',
    config = [[require('config.nvim-transparent')]]
  }
  use "antoinemadec/FixCursorHold.nvim"

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true, }, 
    config = [[require('config.lualine')]]
  }

  -- VimWiki
  use 'vimwiki/vimwiki'

  -- Terminal
  use { 
    "akinsho/toggleterm.nvim",
    config = [[require('config.toggleterm')]]
  }

  -- Wilder
--   use {
--       "gelguy/wilder.nvim",
--       config = [[require('config.wilder')]]
--   }

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- cmp plugins
  use {
    "hrsh7th/nvim-cmp",
    --commit = "d93104244c3834fbd8f3dd01da9729920e0b5fe7",
    config = [[require('config.cmp')]]
  } -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-emoji"
  use "hrsh7th/cmp-nvim-lua"
  --[[use {
    "tzachar/cmp-tabnine",
    config = function()
      local tabnine = require "cmp_tabnine.config"
      tabnine:setup {
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = "..",
        ignored_file_types = { -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
      }
    end,

    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  }--]]

  -- Java
  use "mfussenegger/nvim-jdtls"

  -- LSP
  use {
      "neovim/nvim-lspconfig",
      config = [[require('config.lsp')]]
    } -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  use {
    "filipdutescu/renamer.nvim",
    config = [[require('config.renamer')]]
  }
  use "simrat39/symbols-outline.nvim"
  use "ray-x/lsp_signature.nvim"
  use "b0o/SchemaStore.nvim"
  use {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  }
  --use "github/copilot.vim"
  use "RRethy/vim-illuminate"
  --use { 
  --  "simrat39/rust-tools.nvim",
  --  config = [[require('config.rust-tools')]]
  --}

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = [[require('config.treesitter')]]
  }
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use { "p00f/nvim-ts-rainbow" }
  -- use {'christianchiarulli/nvim-ts-rainbow'}
--  use "nvim-treesitter/playground"
  use "windwp/nvim-ts-autotag"
  use "romgrk/nvim-treesitter-context"
  use "mizlan/iswap.nvim"

  -- Git
  use {
    "f-person/git-blame.nvim",
    config = [[require('config.git-blame')]]
  }
  use {
    "lewis6991/gitsigns.nvim",
    config = [[require('config.gitsigns')]]
  }
  use {
    "ruifm/gitlinker.nvim",
    config = [[require('config.gitlinker')]]
  }
  use "mattn/vim-gist"
  use "mattn/webapi-vim"
  use "https://github.com/rhysd/conflict-marker.vim"

  -- neoscroll
  use {
    'karb94/neoscroll.nvim',
    config = [[require('config.neoscroll')]]
  }

  -- bufferline
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('config.bufferline')]]
  }

  -- indent-blankline
  use {
    'lukas-reineke/indent-blankline.nvim'--,
    --config = require('config.indent-blankline')
  }

  -- for some reasond oesn't work in lua file
  require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
    buftype_exclude = { "terminal" },
    filetype_exclude = { "packer", "alpha", "help", "git", "markdown", "snippets", "text", "gitconfig" },
  }

  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- nvim-notify
  use {
    'rcarriga/nvim-notify',
    config = [[require('config.notify')]]
  }

  -- NeoZoom
  use { 'nyngwang/NeoZoom.lua' }

  -- Nvim-comment
  use {
    'terrortylor/nvim-comment',
    config = [[require('config.nvim-comment')]]
  }

  end)
