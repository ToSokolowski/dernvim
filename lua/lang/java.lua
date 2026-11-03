-- Java via jdtls (Eclipse JDT Language Server) and nvim-jdtls.
-- Imports Maven, Gradle and Eclipse projects (.project/.classpath, e.g. for Ant builds).
-- Java inside sbt/Mill builds is left to Metals (lang/scala.lua).
vim.pack.add { 'https://github.com/mfussenegger/nvim-jdtls' }

local scala = require 'lang.scala'

-- Same order as nvim-lspconfig: prefer the top of multi-module builds, then single projects.
local multi_module_markers = { 'mvnw', 'gradlew', 'settings.gradle', 'settings.gradle.kts', '.git' }
local project_markers = { 'build.xml', 'pom.xml', 'build.gradle', 'build.gradle.kts', '.project' }

-- Paths below come from the Nix wrapper (flake.nix); without it, Java still works
-- but without debugging, test running or the extra JDK.

-- Debugger (java-debug) and test runner (vscode-java-test) add-ons for jdtls
local bundles = {}
if vim.env.DERNVIM_JAVA_DEBUG then vim.list_extend(bundles, vim.fn.glob(vim.env.DERNVIM_JAVA_DEBUG .. '/com.microsoft.java.debug.plugin-*.jar', true, true)) end
if vim.env.DERNVIM_JAVA_TEST then
  for _, jar in ipairs(vim.fn.glob(vim.env.DERNVIM_JAVA_TEST .. '/*.jar', true, true)) do
    local name = vim.fs.basename(jar)
    -- These two are runtime helpers, not jdtls bundles (see nvim-jdtls README)
    if name ~= 'com.microsoft.java.test.runner-jar-with-dependencies.jar' and name ~= 'jacocoagent.jar' then table.insert(bundles, jar) end
  end
end

-- JDKs that projects compile and run against. jdtls itself runs on the newer JDK from PATH.
local runtimes = {}
if vim.env.DERNVIM_JDK17 then table.insert(runtimes, { name = 'JavaSE-17', path = vim.env.DERNVIM_JDK17, default = true }) end

local function on_attach(_, bufnr)
  local jdtls = require 'jdtls'
  local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'Java: ' .. desc }) end
  map('n', '<leader>jo', jdtls.organize_imports, '[O]rganize imports')
  map({ 'n', 'x' }, '<leader>jv', function() jdtls.extract_variable { visual = vim.fn.mode() ~= 'n' } end, 'Extract [V]ariable')
  map({ 'n', 'x' }, '<leader>jc', function() jdtls.extract_constant { visual = vim.fn.mode() ~= 'n' } end, 'Extract [C]onstant')
  map('x', '<leader>jm', function() jdtls.extract_method { visual = true } end, 'Extract [M]ethod')
  map('n', '<leader>ju', function() jdtls.update_projects_config() end, '[U]pdate project config')
  -- Tests run under the debugger, so breakpoints work
  map('n', '<leader>jt', jdtls.test_nearest_method, 'Debug nearest [T]est method')
  map('n', '<leader>jT', jdtls.test_class, 'Debug [T]est class')
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('dernvim-jdtls', { clear = true }),
  pattern = 'java',
  callback = function(ev)
    if scala.is_project(ev.buf) then return end

    local root = vim.fs.root(ev.buf, multi_module_markers) or vim.fs.root(ev.buf, project_markers) or vim.fs.dirname(vim.api.nvim_buf_get_name(ev.buf))
    -- jdtls keeps per-project index data here; the hash keeps same-named projects apart.
    local workspace = vim.fn.stdpath 'cache' .. '/jdtls/' .. vim.fs.basename(root) .. '-' .. vim.fn.sha256(root):sub(1, 8)

    require('jdtls').start_or_attach({
      cmd = { 'jdtls', '-data', workspace },
      root_dir = root,
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = on_attach,
      init_options = { bundles = bundles },
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = 'interactive',
            runtimes = runtimes,
          },
          eclipse = { downloadSources = true },
          maven = { downloadSources = true },
          references = { includeDecompiledSources = true },
          signatureHelp = { enabled = true },
        },
      },
    }, {
      -- Registers the Java debug adapter; `:DapNew` / <F5> then offers the project's main classes.
      -- Changed code is hot-swapped into a running debug session on save.
      dap = { hotcodereplace = 'auto' },
    })
  end,
})
