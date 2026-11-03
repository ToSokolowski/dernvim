# My Neovim Config

Neovim configuration packaged as a Nix flake.

## Plugins

Requires **Neovim 0.12+**. Like current kickstart.nvim, this configuration uses
Neovim's built-in `vim.pack`, not lazy.nvim. Git is included in the Nix wrapper.
Plugins are installed on first launch (network access required) and loaded
eagerly, with dependencies loaded before configuration.

- Inspect plugins: `:lua vim.pack.update(nil, { offline = true })`
- Update plugins: `:lua vim.pack.update()` (review and confirm the update buffer)
- Remove unused plugins: `:lua vim.pack.del { 'plugin-name' }`
- Add plugins using `vim.pack.add` and explicit `setup()` calls in the matching
  module under `lua/plugins/` (or `lua/lang/` for language-specific setup).

## Layout

```
init.lua              leader, then requires the modules below
lua/config/           options, global keymaps, autocmds (incl. plugin build hooks)
lua/plugins/init.lua  load order of the plugin modules
lua/plugins/*.lua     ui, editor, git, telescope, completion, lsp, format, treesitter
lua/lang/*.lua        clojure (Conjure), scala (Metals), typst (preview, :OpenPdf)
```

Treesitter parsers are compiled on first launch into `stdpath('data')` with the
`tree-sitter` CLI and `gcc` from the Nix wrapper; the list is in
`lua/plugins/treesitter.lua`.

`vim.pack` maintains `nvim-pack-lock.json` in `stdpath('config')`; keep that file
under version control if that directory is your config checkout. With the Nix
wrapper, it lives in your user config directory, not the read-only Nix store.
The old `lazy-lock.json` is not imported. Existing Lazy installations are left
untouched; after verifying the migration, you can remove the old `lazy/`
directory under `stdpath('data')` yourself.

## Clojure, Babashka and Fennel

Conjure provides source-buffer evaluation for all three languages. Clojure and
Babashka connect over nREPL; plain Fennel uses a separate REPL over stdio.
Clojure LSP provides completion, diagnostics, navigation, refactoring and
formatting independently of the REPL (including `.bb` scripts).

The wrapped editor includes `clojure`, `bb`, `clojure-lsp` and `fennel`. Run
`nix run .` to use it, then let `vim.pack` install the plugins on first launch. These executables are on the editor's PATH, not automatically your
shell's PATH. Use `:terminal` for the commands below, or install the runtimes
separately for use in an external shell. Run commands from your project root.

### JVM Clojure

Add a development alias to your project's `deps.edn` (merge with existing
aliases rather than replacing them):

```clojure
{:aliases
 {:nrepl
  {:extra-deps {nrepl/nrepl {:mvn/version "1.3.1"}
                cider/cider-nrepl {:mvn/version "0.50.2"}}
   :main-opts ["-m" "nrepl.cmdline"
               "--bind" "127.0.0.1"
               "--middleware" "[cider.nrepl/cider-middleware]"]}}}
```

Start it with `clojure -M:nrepl`. Conjure discovers the project's `.nrepl-port`
when you open a Clojure buffer. If the buffer was already open, run
`:ConjureConnect` to retry discovery, or `:ConjureConnect PORT` to connect
explicitly. Keep `.nrepl-port` out of version control. The first launch needs
network access to fetch Maven dependencies.

Conjure's fallback auto-started Babashka REPL is disabled so a JVM project
cannot silently evaluate in the wrong runtime. REPL startup is explicit;
there is no jack-in helper configured yet.

### Babashka

Start a local server:

```sh
bb --nrepl-server 127.0.0.1:1667
```

Open a `.bb` or `.clj` file and run `:ConjureConnect 1667`. Babashka supplies
its own nREPL implementation; do not add JVM CIDER middleware to it. Its
available tooling operations differ from JVM Clojure.

### Fennel

Open a `.fnl` file. Conjure starts the bundled `fennel` executable as an
external REPL automatically; no nREPL server or middleware is required.
The same evaluation and log mappings work here. Use `Space cs` to start the
REPL if stopped, and `Space cS` to stop it.

This is **plain Fennel**, not Aniseed: it does not require Aniseed's `module`,
`def` or `defn` macros. The REPL is a separate Lua process and cannot directly
access Neovim's `vim` API. For interactive Neovim configuration/plugin work,
Conjure also offers an in-process Aniseed backend, but that is not enabled.
Fennel LSP and structural editing are not configured by this change.

### Evaluation keys

Both leader and local leader are Space in this configuration. Conjure's
mappings are local to supported buffers:

| Keys | Action |
| --- | --- |
| `Space ee` | Evaluate current form |
| `Space er` | Evaluate top-level/root form |
| `Space eb` | Evaluate buffer |
| `Space e` in Visual mode | Evaluate selection |
| `Space ls` | Open evaluation log in a split |
| `Space tn` | Run Clojure namespace tests |
| `Space tc` | Run Clojure test under cursor |
| `Space f` | Format using the existing formatter/LSP integration |

Test commands depend on runtime/middleware support; they are not generic
Fennel test commands. Clojure formatting falls back to clojure-lsp; no Fennel
formatter is configured. Use `:ConjureSchool` for an interactive evaluation
tutorial and `:help conjure` for connection and mapping details.

Keep nREPL bound to localhost: it allows arbitrary code execution. Shut down
servers in their terminal with Ctrl-C when finished.

## Scala / Metals

Metals is available inside the wrapped Neovim. To also make the `metals`
command available in your shell, install the separate package from this checkout:

```sh
nix profile install .#metals
```

For a declarative NixOS or Home Manager configuration, add
`dernvim.packages.${pkgs.stdenv.hostPlatform.system}.metals` to
`environment.systemPackages` or `home.packages`, respectively, where `dernvim`
is this flake's input. This uses the same pinned Metals package as Neovim.
