vim.o.background = 'dark'
vim.cmd 'highlight clear'
if vim.fn.exists 'syntax_on' then
  vim.cmd 'syntax reset'
end
vim.g.colors_name = 'bamboo-cyan'

local C = {
  -- Darkened Background (Near-black Cyan)
  back = '#141b1e', -- Darker than before
  base = '#d1d1c7', -- Soft parchment
  surface = '#1c2529', -- Slightly lighter for UI
  highlight = '#283339', -- Selection
  visual_bg = '#1c3b2b', -- Dark green selection (transparent feel)
  cursorline = '#1a2327', -- Subtle highlight for the current line

  -- The Orange Splash
  orange = '#e67e5e', -- Burnt orange/rust
  bright_orange = '#ff8f40', -- For constants/numbers

  -- Bamboo/Cyan Accents
  green = '#8abb72', -- Bamboo green
  aqua = '#71d5cf', -- Misty aqua
  blue = '#6eb4d1', -- Cyan-blue
  gold = '#dbb671', -- Muted gold
  orchid = '#c68aee', -- Magenta

  -- UI Specifics
  comment = '#505a60',
  line_nr = '#465055', -- Slightly brighter so line numbers aren't hidden
  gutter = '#141b1e',
  none = 'NONE',
}

local function hi(group, fg, bg, opts)
  opts = opts or {}
  local cmd = 'highlight ' .. group
  if fg then
    cmd = cmd .. ' guifg=' .. fg
  else
    cmd = cmd .. ' guifg=NONE'
  end
  if bg then
    cmd = cmd .. ' guibg=' .. bg
  else
    cmd = cmd .. ' guibg=NONE'
  end
  if opts.bold then
    cmd = cmd .. ' gui=bold'
  end
  if opts.italic then
    cmd = cmd .. ' gui=italic'
  end
  if opts.underline then
    cmd = cmd .. ' gui=underline'
  end
  vim.cmd(cmd)
end

-- --- UI Elements ---
hi('Normal', C.base, C.back)
hi('NormalFloat', C.base, C.surface)
hi('LineNr', C.line_nr, C.gutter)
hi('CursorLine', nil, C.cursorline)
hi('CursorLineNr', C.aqua, C.cursorline, { bold = true }) -- Aqua bold line number on current line
hi('Visual', nil, C.visual_bg) -- Deep green subtle background for selection
hi('Search', C.back, C.orange) -- Orange search highlights
hi('IncSearch', C.back, C.bright_orange)

-- --- Syntax Highlighting ---
hi('Comment', C.comment, nil, { italic = true })
hi('Keyword', C.orchid) -- Control flow
hi('Function', C.blue) -- Functions
hi('Type', C.gold) -- Types
hi('String', C.green) -- Strings

-- --- The Orange Splash (Constants & PreProc) ---
hi('Constant', C.bright_orange) -- Numbers/Booleans pop in orange
hi('Number', C.bright_orange)
hi('Boolean', C.bright_orange)
hi('PreProc', C.orange) -- #include, #define
hi('Include', C.orange) -- Modules/Includes

-- --- Cyan/Aqua Details ---
hi('Operator', C.aqua)
hi('Identifier', C.base)
hi('Special', C.aqua)

-- --- Treesitter ---
hi('@comment', C.comment, nil, { italic = true })
hi('@keyword', C.orchid)
hi('@string', C.green)
hi('@function', C.blue)
hi('@type', C.gold)
hi('@operator', C.aqua)
hi('@constant', C.bright_orange) -- Orange splash for constants
hi('@variable', C.base)
hi('@field', C.aqua)
hi('@property', C.aqua)
hi('@parameter', C.base)

-- --- Diagnostics & LSP ---
hi('DiagnosticError', C.orange)
hi('DiagnosticWarn', C.gold)
hi('PmenuSel', C.back, C.orange) -- Orange selection in autocomplete
hi('MatchParen', C.bright_orange, C.highlight, { bold = true })
