return {
  "scalameta/nvim-metals",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "j-hui/fidget.nvim",
    'saghen/blink.cmp',
  },
  ft = { "scala", "sbt", "java" },
  keys = {
    { '<leader>mc', '<CMD>lua require("telescope").extensions.metals.commands()<CR>', mode = 'n' },
  },
  opts = function()
    local metals_config = require("metals").bare_config()
    local lspSettings = require('ram.lsp_settings')

    metals_config.on_attach = function(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
      lspSettings.on_attach(client, bufnr)
    end
    metals_config.find_root_dir_max_project_nesting = 3
    metals_config.init_options.statusBarProvider = "off"
    metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()
    metals_config.cmd_env = {
      JAVA_HOME = "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home",
    }
    metals_config.settings = {
      javaHome = "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home",
      defaultBspToBuildTool = true,
      serverProperties = {
        "-Xmx16G",
        "-XX:MaxMetaspaceSize=4G",
        "--add-opens=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED",
        "--add-opens=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED",
        "--add-opens=jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED",
        "--add-opens=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED",
        "--add-opens=jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED",
        "--add-opens=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED",
        "--add-opens=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED",
        "--add-opens=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED",
      },
    }
    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end
}
