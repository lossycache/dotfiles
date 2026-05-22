return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' }
  },
  config = function()
    require('nvim-treesitter').setup {}
    require('nvim-treesitter').install { 'scala', 'go', 'yaml', 'terraform', 'bash' }

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Remap built-in 0.12 node selection keys to match previous incremental_selection config
    vim.keymap.set({ 'n', 'x' }, '<C-space>', 'an', { remap = true })
    vim.keymap.set('x', '<bs>', 'in', { remap = true })
  end
}
