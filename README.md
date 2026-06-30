My [Helix](https://helix-editor.com) config as a Nix flake.
Bundles the editor + all LSPs into a single reproducible package.

## Supported Systems

- `x86_64-linux`
- `aarch64-linux`
- `aarch64-darwin`

## Supported Languages

Bash, C, C++, C#, Docker, Go, Helm, HTML, CSS, JSON, Java, JavaScript, TypeScript, jq, Just, Lua, Markdown, Meson, Nix, Odin, PHP, Python, QML, Ruby, Rust, TOML, Typst, YAML, Zig

## Try it

With flakes enabled:

```bash
nix run github:yvnth/yvnthx
```

Without flakes enabled:

```bash
nix --extra-experimental-features 'nix-command flakes' run github:yvnth/yvnthx
```

## Use in your flake

```nix
inputs = {
  yvnthx = {
    url = "github:yvnth/yvnthx";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

### With Home Manager

```nix
imports = [ inputs.yvnthx.homeManagerModules.default ];
```

### Without Home Manager

Add to your NixOS config:

```nix
environment.systemPackages = [ inputs.yvnthx.packages.${system}.default ];
```
