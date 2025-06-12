final: prev: {
  falcon-sensor-unwrapped = final.callPackage ./falcon-sensor-unwrapped.nix {};
  falcon-sensor = final.callPackage ./falcon-sensor.nix {};
}