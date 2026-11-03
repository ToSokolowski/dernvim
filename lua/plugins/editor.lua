do
  vim.pack.add { 'https://github.com/NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}
end

do
  vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' }
  vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
  require('oil').setup {}
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
end

do
  vim.pack.add { 'https://github.com/folke/flash.nvim' }
  require('flash').setup {}
  vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
end

do
  vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
  vim.pack.add { { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' } }
  local harpoon = require 'harpoon'
  harpoon:setup()

  vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon [A]dd file' })
  vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })

  -- Jump to files 1-4
  for i = 1, 4 do
    vim.keymap.set('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon file ' .. i })
  end
end

do
  vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
  vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }
end

do
  vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
  -- Better Around/Inside textobjects
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup { n_lines = 500 }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  --  - sd'   - [S]urround [D]elete [']quotes
  --  - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()
end
