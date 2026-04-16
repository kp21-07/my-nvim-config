local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function OpenFloatingWindow(opts)
  opts = opts or {}
  local width = math.floor(opts.width or vim.o.columns * 0.8)
  local height = math.floor(opts.height or vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local buf
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  local win_opts = {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded',
    title = ' Terminal ',
    title_pos = 'center',
  }
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = OpenFloatingWindow { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
    vim.cmd 'startinsert'
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local filetype_commands = {
  python = 'python3 %s',
  javascript = 'node %s',
  lua = 'lua %s',
  sh = 'bash %s',
  go = 'go run %s',
  rust = 'cargo run',
  odin = 'odin run .',
  c = function(file)
    local name = vim.fn.fnamemodify(file, ':t:r')
    return string.format('gcc -Wall -g %s -o %s && ./%s', file, name, name)
  end,
  cpp = function(file)
    local name = vim.fn.fnamemodify(file, ':t:r')
    return string.format('g++ -Wall -g %s -o %s && ./%s', file, name, name)
  end,
}

local run_current_file = function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand '%'
  local command_entry = filetype_commands[ft]

  if not command_entry then
    vim.notify('No run command defined for filetype: ' .. ft, vim.log.levels.WARN)
    return
  end

  local command
  if type(command_entry) == 'function' then
    command = command_entry(file)
  elseif ft == 'rust' and vim.fn.filereadable 'Cargo.toml' == 1 then
    command = 'cargo run'
  else
    command = string.format(command_entry, file)
  end

  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = OpenFloatingWindow { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  end

  vim.cmd 'startinsert'

  -- Wait a bit for terminal to be ready if valid
  local job_id = vim.b[state.floating.buf].terminal_job_id
  if job_id then
    vim.api.nvim_chan_send(job_id, command .. '\r\n')
  end
end

vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
vim.keymap.set({ 'n', 't' }, '<space>tt', toggle_terminal, { desc = 'Toggle Floating Terminal' })
vim.keymap.set('n', '<space>tr', run_current_file, { desc = 'Run Current File' })

