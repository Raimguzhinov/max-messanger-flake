# max-messanger-flake

## Installation

Just add it to your NixOS `flake.nix` or home-manager:

```nix
inputs = {
  # ...
  max-messanger.url = "github:Raimguzhinov/max-messanger-flake";
}
```

### Integration

To integrate `MAX Messanger` to your NixOS/Home Manager configuration, add the
following to your `environment.systemPackages` or `home.packages`:

```nix
environment.systemPackages = with pkgs; [
  # ...
  max-messanger.packages.${system}.default
];
```

Afterwards you can just build your configuration

```shell
$ sudo nixos-rebuild switch # or home-manager switch
```
