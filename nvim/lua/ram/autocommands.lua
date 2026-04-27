-- automatically open Telescope find_files if vim opened with no file
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('VimEnter_Telescope', { clear = true }),
  callback = function()
    if vim.fn.argv(0) == '' then
      require('telescope.builtin').find_files()
    end
  end,
})

-- After a branch checkout in dd-go, rake tidy runs in the background via a
-- post-checkout git hook. When it finishes, it touches a sentinel file.
-- On FocusGained we check for that file and restart gopls automatically.
vim.api.nvim_create_autocmd('FocusGained', {
  group = vim.api.nvim_create_augroup('dd_go_post_tidy', { clear = true }),
  callback = function()
    local sentinel = '/tmp/dd-go-tidy-done'
    if vim.uv.fs_stat(sentinel) then
      os.remove(sentinel)
      vim.cmd('LspRestart gopls')
      vim.notify('rake tidy completed — restarting gopls', vim.log.levels.INFO)
    end
  end,
})
