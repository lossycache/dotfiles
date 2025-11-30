return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  lazy = true,
  config = function()
    require('nvim-treesitter.configs').setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Select outer part of a function definition" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of a function definition" },
          }
        },
      }
    })
  end
}
