return {
  -- Mason: LSP installer
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },

  -- Bridge Mason to LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "tsserver", "lua_ls" }, -- add what you need
        automatic_installation = true,
      })

      -- Auto-setup installed servers with lspconfig
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities
          }
        end,
      }
    end,
  }
}

