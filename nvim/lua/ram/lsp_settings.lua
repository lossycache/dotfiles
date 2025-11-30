local vim = vim

local M = {}

M.setup = function()
  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

M.lsp_highlight_document = function(bufnr)
  local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
  vim.api.nvim_create_autocmd(
    {
      "CursorHold"
    },
    {
      buffer = bufnr,
      group = group,
      command = "lua vim.lsp.buf.document_highlight()"
    }
  )

  vim.api.nvim_create_autocmd(
    {
      "CursorMoved"
    },
    {
      buffer = bufnr,
      group = group,
      command = "lua vim.lsp.buf.clear_references()"
    }
  )
end

M.lsp_format_document = function(bufnr)
  vim.api.nvim_create_autocmd(
    {
      "BufWritePre"
    },
    {
      buffer = bufnr,
      group = vim.api.nvim_create_augroup('lsp_format_document', { clear = true }),
      command = "lua vim.lsp.buf.format()"
    }
  )
end

M.lsp_keymaps = function(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>:Telescope lsp_definitions<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover({ border = 'rounded' })<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>:Telescope lsp_references<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "gl",
    '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
    opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_create_user_command(
    bufnr,
    'Format',
    function()
      vim.lsp.buf.format({ async = true })
    end,
    {}
  )
end

M.on_attach = function(client, bufnr)
  M.lsp_keymaps(bufnr)

  if client.server_capabilities.documentHighlightProvider then
    M.lsp_highlight_document(bufnr)
  end

  if client.server_capabilities.documentFormattingProvider then
    M.lsp_format_document(bufnr)
  end
end

return M
