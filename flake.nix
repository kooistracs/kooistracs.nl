{
  description = "Zola + TailwindCSS dev. environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/25.05";
  
  outputs = inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            zola
            tailwindcss
            just
          ];
        };
      });
    };
}
