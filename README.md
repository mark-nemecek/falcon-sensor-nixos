# Crowdstrike Falcon Sensor on NixOS

This was originally forked from a gist by @mrcjkb at https://gist.github.com/mrcjkb/6057932e51af8aade20896e2ad10b6f9 and modified by @benley

For now, to use this you'll probably need to edit `falcon-sensor-unwrapped.nix` to point at your particular version of the falcon-sensor .deb file.

Then add the flake to your system's `flake.nix`:

```nix
{
  # ...
  
  inputs.falcon-sensor = {
    url = "https://github.com/benley/falcon-sensor-nixos";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, falcon-sensor, ... }@inputs: {
    nixosConfigurations = {
      "my-hostname" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          falcon-sensor.nixosModules.falcon-sensor
        ];
      };
    };
  };
}
```

And enable it in your `configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  # ...
  
  services.falcon-sensor = {
    enable = true;
    cid = "YOUR_CUSTOMER_ID_HERE";
    # If you don't do this, the module will override boot.kernelPackages
    # which may or may not work for you.
    kernelPackages = null;
  };
}
```
