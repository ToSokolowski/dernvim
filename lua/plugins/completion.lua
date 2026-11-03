vim.pack.add { { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' } }
require('luasnip').setup {}
require('blink.cmp').setup {
  keymap = {
    -- 'default': <c-y> to accept, <c-space> to open menu/docs, <c-n>/<c-p> to select,
    -- <c-e> to hide, <c-k> for signature help, <tab>/<s-tab> to move in snippets.
    -- See :h blink-cmp-config-keymap and `:help ins-completion`
    preset = 'default',
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    nerd_font_variant = 'mono',
  },

  completion = {
    -- Press `<c-space>` to show the documentation, or set `auto_show = true`.
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  snippets = { preset = 'luasnip' },

  -- Lua matcher; 'prefer_rust_with_warning' downloads a prebuilt Rust binary.
  -- See :h blink-cmp-config-fuzzy
  fuzzy = { implementation = 'lua' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}
