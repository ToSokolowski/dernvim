-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Run build steps after vim.pack installs or updates a plugin.
-- Registered before any vim.pack.add so it also fires on first install.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('dernvim-plugin-builds', { clear = true }),
  callback = function(ev)
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    local name = ev.data.spec.name
    if name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
      return
    end
    local cmd
    if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      cmd = { 'make' }
    elseif name == 'LuaSnip' and vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
      cmd = { 'make', 'install_jsregexp' }
    end
    if cmd then
      local result = vim.system(cmd, { cwd = ev.data.path }):wait()
      if result.code ~= 0 then error(('Build failed for %s:\n%s\n%s'):format(name, result.stdout or '', result.stderr or '')) end
    end
  end,
})

-- OPEN OIL ON OPENING A DIR
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      local dir = vim.fn.argv(0)
      require('oil').open(dir)
      pcall(function() vim.cmd 'argdelete *' end)
    end
  end,
})
