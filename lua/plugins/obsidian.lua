-- [[ Emergency Obsidian ]]
-- Vault editing (wikilinks, backlinks, daily notes, search) without the Obsidian app.
-- Link/tag completion comes from obsidian.nvim's built-in LSP server (picked up by blink.cmp).
vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add {
  { src = 'https://github.com/obsidian-nvim/obsidian.nvim', version = vim.version.range '*' },
}
vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

---@module 'obsidian'
---@type obsidian.config
require('obsidian').setup {
  legacy_commands = false,
  workspaces = {
    { name = 'vault', path = '~/sync/vault' },
    { name = 'obsidian', path = '~/Documents/Obsidian' },
    { name = 'general', path = '~/Documents/General' },
    { name = 'learning', path = '~/Documents/Learning' },
  },
  picker = { name = 'telescope.nvim' },
  daily_notes = { folder = 'daily' },
  -- render-markdown.nvim handles rendering; avoids the conceallevel warning too
  ui = { enable = false },
}

---@module 'render-markdown'
---@type render.md.UserConfig
require('render-markdown').setup {}

vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<cr>', { desc = '[O]bsidian [N]ew note' })
vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<cr>', { desc = '[O]bsidian [S]earch' })
vim.keymap.set('n', '<leader>oq', '<cmd>Obsidian quick_switch<cr>', { desc = '[O]bsidian [Q]uick switch' })
vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<cr>', { desc = '[O]bsidian [B]acklinks' })
vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian tags<cr>', { desc = '[O]bsidian [T]ags' })
vim.keymap.set('n', '<leader>od', '<cmd>Obsidian today<cr>', { desc = '[O]bsidian [D]aily note' })
vim.keymap.set('n', '<leader>ow', '<cmd>Obsidian workspace<cr>', { desc = '[O]bsidian [W]orkspace' })
