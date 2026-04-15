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
        metals
        luarocks

        basedpyright # Python
        rust-analyzer # Rust
        haskell-language-server # Haskell
        metals # Scala
        bloop

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
            luafile ${./init.lua}
          '';
        };
      };
    in {
      packages.default = pkgs.symlinkJoin {
        name = "nvim";
        paths = [kickstart-nvim];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/nvim \
          --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps}
        '';
      };

      apps.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/nvim";
      };
    });
}
