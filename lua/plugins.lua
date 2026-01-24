return {
  {
    'NMAC427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {}
    end,
  },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    lazy = false,
  },
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },
  { 'folke/lazydev.nvim', ft = 'lua', opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } } },
  { import = 'plugins.lspconfig' },
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return { timeout_ms = 500, lsp_format = 'fallback' }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },
  -- { -- Autocompletion
  --   'saghen/blink.cmp',
  --   event = 'VimEnter',
  --   version = '1.*',
  --   dependencies = {
  --     {
  --       'L3MON4D3/LuaSnip',
  --       version = '2.*',
  --       build = function()
  --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --           return nil
  --         end
  --         return 'make install_jsregexp'
  --       end,
  --       dependencies = {
  --         {
  --           'rafamadriz/friendly-snippets',
  --           config = function()
  --             require('luasnip.loaders.from_vscode').lazy_load()
  --           end,
  --         },
  --       },
  --       opts = {},
  --     },
  --     'folke/lazydev.nvim',
  --   },
  --   opts = {
  --     keymap = { preset = 'default' },
  --     appearance = { nerd_font_variant = 'mono' },
  --     completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
  --     sources = {
  --       default = { 'lsp', 'path', 'snippets', 'lazydev' },
  --       providers = { lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 } },
  --     },
  --     snippets = { preset = 'luasnip' },
  --     fuzzy = { implementation = 'lua' },
  --     signature = { enabled = true },
  --   },
  -- },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'bamboo',
          icons_enabled = true,
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = { 'NvimTree' }, -- Don't show a statusline in the file tree
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            'diff',
            'gitsigns', -- Shows the number of added, removed, and modified lines
          },
          lualine_c = {
            { 'filename', path = 1 }, -- Shows the full path to the file
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ' },
              colored = true,
              update_in_insert = true,
              diagnostics_mode = 'lsp-only',
            },
            {
              function()
                return require('nvim-navic').get_location()
              end,
              cond = function()
                return require('nvim-navic').is_available()
              end,
            },
          },
          lualine_x = {
            {
              'filetype',
              colored = true,
              icon_only = true,
              section_separators = { left = '', right = '' },
              component_separators = { left = '', right = '' },
            },
            {
              function()
                local msg = 'No Active Lsp'
                local clients = vim.lsp.get_clients { bufnr = 0 }
                if next(clients) == nil then
                  return msg
                end
                
                local client_names = {}
                for _, client in ipairs(clients) do
                  table.insert(client_names, client.name)
                end
                return 'LSP: ' .. table.concat(client_names, ', ')
              end,
              icon = '',
            },
            {
              function()
                local shiftwidth = vim.api.nvim_buf_get_option(0, 'shiftwidth')
                return 'Spaces: ' .. shiftwidth
              end,
            },
            'encoding',
            'fileformat',
            'searchcount',
            -- 'progress',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },
  {
    'ribru17/bamboo.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('bamboo').setup {
        -- optional configuration here
      }
      require('bamboo').load()
    end,
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'ocaml', 'ocaml_interface' },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
}
