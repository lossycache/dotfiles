return {
  'neovim/nvim-lspconfig',
  dependencies = { 'saghen/blink.cmp' },
  lazy = false,
  config = function()
    local lspSettings = require('ram.lsp_settings')
    lspSettings.setup()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    vim.lsp.config.eslint = {
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        lspSettings.on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    }

    vim.lsp.config.vtsls = {
      on_attach = lspSettings.on_attach,
      settings = {
        typescript = {
          tsserver = {
            maxTsServerMemory = 12288
          },
        },
        vtsls = {
          autoUseWorkspaceTsdk = true
        }
      },
      capabilities = capabilities,
    }

    vim.lsp.config.terraformls = {
      on_attach = lspSettings.on_attach,
      capabilities = capabilities,
    }

    vim.lsp.config.buf_ls = {
      root_markers = { "buf.yaml", ".git" },
      on_attach = lspSettings.on_attach,
      capabilities = capabilities,
    }

    vim.lsp.config.lua_ls = {
      on_attach = lspSettings.on_attach,
      capabilities = capabilities,
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })
      end,
      settings = {
        Lua = {}
      }
    }

    -- require('go').setup({})
    vim.lsp.config.gopls = {
      cmd = { "dd-gopls" },
      cmd_env = {
        GOPLS_DISABLE_MODULE_LOADS = "1",
      },
      capabilities = capabilities,
      filetypes = { "go", "gomod" },
      root_markers = { "go.work", "go.mod" },
      settings = {
        gopls = {
          semanticTokens = true,
          buildFlags = { "-tags=" }, -- empty tag set means don't include any files that have build constraints
          analyses = {
            unusedparams = true,
          },
          completeUnimported = false,
          staticcheck = true,
        },
      },
      on_attach = lspSettings.on_attach
    }

    vim.lsp.config.basedpyright = {
      on_attach = lspSettings.on_attach,
      capabilities = capabilities,
    }

    vim.lsp.config.clangd = {
      on_attach = lspSettings.on_attach,
      capabilities = capabilities,
    }

    vim.lsp.enable({ 'terraformls', 'buf_ls', 'lua_ls', 'gopls', 'basedpyright', 'clangd' })
  end
}
