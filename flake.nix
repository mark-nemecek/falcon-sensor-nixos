{
  description = "Crowdstrike Falcon Sensor for NixOS";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        self.overlays.default
      ];
    };
    module-test = pkgs.callPackage (import ./module-test.nix self.nixosModules.default) {};
    kernel-check = pkgs.callPackage ./kernel-check.nix {};
  in {
    packages.${system} = rec {
      default = falcon-sensor;
      inherit
        (pkgs)
        falcon-sensor
        falcon-sensor-unwrapped
        ;
      inherit
        module-test
        kernel-check
        ;
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "crowdstrike-devShell";
      buildInputs = with pkgs; [
        git-lfs
      ];
    };

    checks.${system}.default = module-test;

    overlays.default = import ./overlay.nix;

    nixosModules.default = import ./nixos-module.nix {falcon-sensor-overlay = self.overlays.default;};
  };
}
