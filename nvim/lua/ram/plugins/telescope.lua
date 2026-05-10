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
      layout_strategy = "vertical",
      layout_config = {
        vertical = {
          preview_height = 0.6, -- preview takes top 60%
        },
        width = 0.9,
        height = 0.9,
        prompt_position = "bottom",
      },
    },
    pickers = {
      find_files = {
        find_command = { "git", "ls-files", "--cached", "--others", "--exclude-standard", "--", ":!third_party" }
      }
    },
  }
}
