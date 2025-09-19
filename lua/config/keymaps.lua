local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  })
end, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files({ cwd = vim.fn.stdpath('config') })
end, { desc = '[S]earch [N]eovim files' })

-- Running Files
vim.keymap.set('n', '<leader>rp', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:sub(-3) == '.py' then
    vim.cmd('split | terminal python3 ' .. vim.fn.shellescape(filepath))
  else
    print('Run Python : Error ( not a python file ).')
  end
end, { desc = '[R]un current [P]ython file' })
vim.keymap.set('n', '<leader>rc', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:sub(-4) == '.cpp' or filepath:sub(-2) == '.c' then
    vim.cmd('split | terminal g++ ' .. vim.fn.shellescape(filepath) .. '&& ./a.out')
  else
    print('Run C/C++ : Error ( not a C/C++ file ).')
  end
end, { desc = '[R]un current [C/C++] file' })
vim.keymap.set('n', '<leader>ro', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:sub(-5) == '.odin' then
    vim.cmd('split | terminal odin run .')
  else
    print('Run Odin : Error ( not an Odin file ).')
  end
end, { desc = '[R]un current [O]din file' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>td', function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({
    virtual_text = not current,
    underline = not current,
    signs = not current,
  })
end, { desc = '[T]oggle [D]iagnostics' })
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { desc = 'Show [E]rror under cursor' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover (docs/errors)' })