# Articles
* [Nix shell with rustup](https://ayats.org/blog/nix-rustup/)
* [How to package my software in nix or write my own package derivation for nixpkgs](https://unix.stackexchange.com/questions/717168/how-to-package-my-software-in-nix-or-write-my-own-package-derivation-for-nixpkgs)

## Optimize storage

```sh
# You can remove all generations older than a specific period:
sudo nix-collect-garbage --delete-older-than 3d

# There are also user-specific generations for different things (eg. home-manager):
nix-collect-garbage -d
```

/nix can reside on another device: https://nixos.wiki/wiki/Storage_optimization#Moving_the_store
