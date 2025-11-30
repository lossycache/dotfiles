return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { "<leader>f",  "<CMD>lua require('telescope.builtin').find_files()<CR>",                      mode = "n", desc = "FindFile" },
    { "<leader>g",  "<CMD>lua require('telescope.builtin').live_grep()<CR>",                       mode = "n", desc = "LiveGrep" },
    { "<leader>og", "<CMD>lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>", mode = "n", desc = "grep in open files" },
    { "gs",         "<CMD>lua require('telescope.builtin').grep_string()<CR>",                     mode = "n", desc = "grep the string under the cursor" },
  },
  opts = {
    defaults = {
      prompt_prefix = ' ',
      selection_caret = '↳ ',
      mappings = {
        i = {
          ["<C-e>"] = "close",
        },
      },
    },
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
      }
    },
  }
}
