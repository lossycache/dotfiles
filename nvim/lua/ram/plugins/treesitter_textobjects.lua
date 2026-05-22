return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  lazy = true,
  config = function()
    require('nvim-treesitter-textobjects').setup { select = { lookahead = true } }
    vim.keymap.set({ 'x', 'o' }, 'af', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
    end, { desc = 'Select outer part of a function definition' })
    vim.keymap.set({ 'x', 'o' }, 'if', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
    end, { desc = 'Select inner part of a function definition' })
  end
}
