{
  description = "yvnth's helix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          lsp = import ./lsp.nix { inherit pkgs; };

          config = pkgs.runCommand "helix-config" { } ''
            mkdir -p $out/helix
            cp -r ${./config}/. $out/helix/
          '';

          hx = pkgs.symlinkJoin {
            name = "hx";
            paths = [ pkgs.helix ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/hx \
                --set HELIX_RUNTIME ${pkgs.helix}/lib/runtime \
                --set XDG_CONFIG_HOME ${config} \
                --prefix PATH : ${nixpkgs.lib.makeBinPath lsp}
            '';
          };
        in
        {
          default = hx;
          helix = hx;
        }
      );

      homeManagerModules.default =
        { pkgs, ... }:
        let
          system = pkgs.stdenv.hostPlatform.system;
        in
        {
          home.packages = [ self.packages.${system}.helix ];
        };
    };
}
