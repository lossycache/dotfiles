return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects'
  },
  config = function()
    require('nvim-treesitter.configs').setup {
      sync_install = false, -- to install languages async
      highlight = {
        enable = true,
        -- disable = { "go" },
      },
      indent = {
        enable = true,
      },
      ensure_installed = {
        "scala",
        "go",
        "yaml",
        "terraform",
        "bash",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>"
        }
      }
    }
  end
}
