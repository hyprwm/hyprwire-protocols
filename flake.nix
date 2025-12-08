{
  description = "Hyprwire Protocols";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # <https://github.com/nix-systems/nix-systems>
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  }: let
    inherit (nixpkgs) lib;
    eachSystem = lib.genAttrs (import systems);
    pkgsFor = eachSystem (system:
      import nixpkgs {
        localSystem = system;
        overlays = [self.overlays.hyprwire-protocols];
      });
    mkDate = longDate: (lib.concatStringsSep "-" [
      (builtins.substring 0 4 longDate)
      (builtins.substring 4 2 longDate)
      (builtins.substring 6 2 longDate)
    ]);
    version = lib.removeSuffix "\n" (builtins.readFile ./VERSION);
  in {
    overlays = {
      default = self.overlays.hyprwire-protocols;
      hyprwire-protocols = final: prev: {
        hyprwire-protocols = final.callPackage ./nix/default.nix {
          version = version + "+date=" + (mkDate (self.lastModifiedDate or "19700101")) + "_" + (self.shortRev or "dirty");
        };
      };
    };

    packages = eachSystem (system: {
      inherit (pkgsFor.${system}) hyprwire-protocols;
      default = self.packages.${system}.hyprwire-protocols;
    });

    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
