{
  description = "Kickstart.nvim as a Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      # Define external dependencies required by kickstart.nvim
      runtimeDeps = with pkgs; [
        git # vim.pack clones and updates plugins
        gcc
        gnumake
        unzip
        wget
        ripgrep
        fd
        xclip # For clipboard support
        lua-language-server
        nil # Nix LSP
        tree-sitter
        nodejs
        luarocks

        clojure # JVM Clojure CLI
        babashka # bb, including its built-in nREPL server
        clojure-lsp # Clojure/Babashka completion, diagnostics and formatting
        luaPackages.fennel # Standalone Fennel REPL for Conjure

        basedpyright # Python
        rust-analyzer # Rust
        haskell-language-server # Haskell
        metals # Scala
        bloop
        jdk25 # metals and jdtls runtime
        jdt-language-server # Java (jdtls)
        ant # Java build tools, for the Neovim terminal
        gradle
        maven
        leiningen # Clojure (project.clj); clojure-lsp uses it for the classpath
        tinymist # Typst
        ltex-ls-plus

        zathura # for lifepreview to work, we install this wonderful pdf viewer

        stylua # Lua
        isort # Python (Sorts imports)
        black # Python (Formats code)
        scalafmt # Scala
        fourmolu # Haskell
        alejandra # Nix
        typstyle # Typst
        rustfmt # Rust
        just # Just (Used as a formatter here)
        taplo # TOML (Note: the package/binary is often 'taplo', not 'tombi')
      ];

      # Wrap Neovim with the init.lua and dependencies
      kickstart-nvim = pkgs.neovim.override {
        configure = {
          customRC = ''
            lua vim.opt.rtp:prepend('${self}')
            luafile ${./init.lua}
          '';
        };
      };
    in {
      # Allow Metals to be installed independently into a user or system profile.
      packages.metals = pkgs.metals;

      packages.default = pkgs.symlinkJoin {
        name = "nvim";
        paths = [kickstart-nvim];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/nvim \
          --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps} \
          --set DERNVIM_JDK17 ${pkgs.jdk17}/lib/openjdk \
          --set DERNVIM_JAVA_DEBUG ${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server \
          --set DERNVIM_JAVA_TEST ${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server
        '';
      };

      apps.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/nvim";
      };
    });
}
