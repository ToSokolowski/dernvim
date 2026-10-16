# My Neovim Config

Neovim configuration packaged as a Nix flake.

Metals is available inside the wrapped Neovim. To also make the `metals`
command available in your shell, install the separate package from this checkout:

```sh
nix profile install .#metals
```

For a declarative NixOS or Home Manager configuration, add
`dernvim.packages.${pkgs.stdenv.hostPlatform.system}.metals` to
`environment.systemPackages` or `home.packages`, respectively, where `dernvim`
is this flake's input. This uses the same pinned Metals package as Neovim.
