do
  vim.pack.add { 'https://github.com/ellisonleao/gruvbox.nvim' }
  require('gruvbox').setup {
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = false, -- Disable italics for strings
      comments = false, -- Disable italics for comments per your preference
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, quiet pastels
    contrast = 'hard', -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  }
  -- Gruvbox follows 'background' for its light/dark variant. Remember the
  -- last selection across sessions, falling back to dark on first use.
  local background_state_file = vim.fn.stdpath 'state' .. '/background'
  local saved_background = vim.fn.filereadable(background_state_file) == 1 and vim.fn.readfile(background_state_file)[1] or nil
  vim.o.background = saved_background == 'light' and 'light' or 'dark'
  vim.cmd 'colorscheme gruvbox'

  -- Toggle between light and dark mode
  vim.keymap.set('n', '<leader>tB', function()
    vim.o.background = vim.o.background == 'light' and 'dark' or 'light'
    vim.fn.writefile({ vim.o.background }, background_state_file)
  end, { desc = '[T]oggle [B]ackground light/dark' })
end

do
  vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' }
end

do
  vim.pack.add { 'https://github.com/folke/which-key.nvim' }
  require('which-key').setup {
    -- delay between pressing a key and opening which-key (milliseconds)
    delay = 500,
    icons = { mappings = vim.g.have_nerd_font },

    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>g', group = '[G]it' },
      { '<leader>c', group = '[C]ode agents', mode = { 'n', 'v' } },
      { '<leader>j', group = '[J]ava', mode = { 'n', 'x' } },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }
end

do
  vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }

  -- Show cursor location as LINE:COLUMN
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end
end

do
  vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
  require('ibl').setup {}
end

do
  vim.pack.add { 'https://github.com/j-hui/fidget.nvim' }
  require('fidget').setup {}
end

-- Inline images (mermaid diagrams, math, image links) via snacks.image.
-- Off by default; <leader>tm toggles rendering in the current buffer.
-- Needs a Kitty-graphics terminal (kitty, ghostty, wezterm); mmdc and magick come from the flake.
do
  vim.pack.add { 'https://github.com/folke/snacks.nvim' }
  require('snacks').setup {
    -- inline/float off: buffers aren't rendered until toggled on
    image = { doc = { inline = false, float = false } },
  }

  local rendered = {} ---@type table<integer, snacks.image.inline>
  local function stop(buf)
    local r = rendered[buf]
    if not r then return end
    -- snacks has no detach for inline rendering; silence the buffer hooks it installed
    r.update = function() end
    r.conceal = function() end
    pcall(vim.api.nvim_del_augroup_by_name, 'snacks.image.inline.' .. buf)
    Snacks.image.placement.clean(buf)
    rendered[buf] = nil
  end

  vim.keymap.set('n', '<leader>tm', function()
    local buf = vim.api.nvim_get_current_buf()
    if rendered[buf] then return stop(buf) end
    if not Snacks.image.terminal.env().placeholders then
      return vim.notify('Inline images need a terminal with Kitty graphics placeholders', vim.log.levels.WARN)
    end
    rendered[buf] = Snacks.image.inline.new(buf)
  end, { desc = '[T]oggle inline [M]ermaid/images' })

  vim.api.nvim_create_autocmd('BufWipeout', {
    group = vim.api.nvim_create_augroup('dernvim-image-toggle', { clear = true }),
    callback = function(ev) rendered[ev.buf] = nil end,
  })
end
