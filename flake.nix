{
  description = "Hyprwire Protocols";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # <https://github.com/nix-systems/nix-systems>
    systems.url = "github:nix-systems/default-linux";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      eachSystem = lib.genAttrs (import systems);
      pkgsFor = eachSystem (
        system:
        import nixpkgs {
          localSystem = system;
          overlays = [ self.overlays.hyprwire-protocols ];
        }
      );
    in
    {
      overlays = import ./nix/overlays.nix { inherit lib self; };

      packages = eachSystem (system: {
        inherit (pkgsFor.${system}) hyprwire-protocols;
        default = self.packages.${system}.hyprwire-protocols;
      });

      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
