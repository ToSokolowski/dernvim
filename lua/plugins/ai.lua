-- Coding agents. All keymaps live under <leader>c ("[C]ode agents").
--  Claude Code: claudecode.nvim speaks Claude's IDE protocol (live selection, native diffs).
--  pi / agy:    sidekick.nvim runs them in a terminal split and sends editor context.
-- The CLIs themselves come from your profile, not this flake.

do
  vim.pack.add { 'https://github.com/coder/claudecode.nvim' }
  require('claudecode').setup {
    -- Built-in terminal split (snacks is only used for images here).
    terminal = { provider = 'native' },
  }

  local map = function(lhs, rhs, desc, mode) vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc }) end
  map('<leader>cc', '<cmd>ClaudeCode<cr>', 'Toggle [C]laude')
  map('<leader>cf', '<cmd>ClaudeCodeFocus<cr>', '[F]ocus Claude')
  map('<leader>cr', '<cmd>ClaudeCode --resume<cr>', '[R]esume Claude')
  map('<leader>cC', '<cmd>ClaudeCode --continue<cr>', '[C]ontinue Claude')
  map('<leader>cm', '<cmd>ClaudeCodeSelectModel<cr>', 'Select Claude [M]odel')
  map('<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', 'Add [B]uffer to Claude')
  map('<leader>cs', '<cmd>ClaudeCodeSend<cr>', '[S]end selection to Claude', 'v')
  -- Diffs proposed by Claude: also :w to accept, :q to deny
  map('<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', '[A]ccept Claude diff')
  map('<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', '[D]eny Claude diff')

  -- In oil, <leader>cs adds the file under the cursor instead
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('dernvim-claudecode-oil', { clear = true }),
    pattern = 'oil',
    callback = function(ev) vim.keymap.set('n', '<leader>cs', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = ev.buf, desc = '[S]end file to Claude' }) end,
  })
end

do
  vim.pack.add { 'https://github.com/folke/sidekick.nvim' }
  require('sidekick').setup {
    -- Next Edit Suggestions need a Copilot subscription; only the CLI part is used.
    nes = { enabled = false },
    cli = {
      picker = 'telescope',
      tools = {
        agy = {
          cmd = { 'agy' },
          is_proc = '\\<agy\\>',
          continue = { '--continue' },
        },
      },
    },
  }

  local cli = require 'sidekick.cli'
  vim.keymap.set('n', '<leader>cp', function() cli.toggle { name = 'pi', focus = true } end, { desc = 'Toggle [P]i' })
  vim.keymap.set('n', '<leader>cg', function() cli.toggle { name = 'agy', focus = true } end, { desc = 'Toggle Anti[G]ravity (agy)' })
  vim.keymap.set('n', '<leader>ct', function() cli.select() end, { desc = 'Select agent [T]ool (sidekick)' })
  vim.keymap.set('n', '<leader>cy', function() cli.send { msg = '{this}' } end, { desc = 'Send this to agent (sidekick)' })
  vim.keymap.set('x', '<leader>cy', function() cli.send { msg = '{selection}' } end, { desc = 'Send selection to agent (sidekick)' })
  vim.keymap.set({ 'n', 'x' }, '<leader>cP', function() cli.prompt() end, { desc = 'Agent [P]rompt picker (sidekick)' })
end
