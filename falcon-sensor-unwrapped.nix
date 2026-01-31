{
  stdenv,
  lib,
  dpkg,
  autoPatchelfHook,
  zlib,
  openssl,
  libnl,
  ...
}:

let
  # Run a command and capture its output as a string (by writing output to the nix store and reading it back)
  runCommandString = command:
    let
      outputDerivation = stdenv.mkDerivation {
        name = "run-command-string";
        buildCommand = ''
          { ${command} } > "$out"
        '';
      };
    in
    builtins.readFile outputDerivation;
in

stdenv.mkDerivation rec {
  pname = "falcon-sensor-unwrapped";
  version = runCommandString ''
    ${dpkg}/bin/dpkg-deb -f ${src} version | tr -d "\n"
  '';
  arch = "x86_64-linux";
  src = ./falcon-sensor_7.33.0-18606_amd64.deb;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    zlib
  ];

  propagatedBuildInputs = [
    openssl
    libnl
  ];

  sourceRoot = ".";

  unpackCmd =
    /*
    bash
    */
    ''
      dpkg-deb -x "$src" .
    '';

  installPhase = ''
    cp -r ./ $out/
  '';

  meta = with lib; {
    mainProgram = "falconctl";
    description = "Crowdstrike Falcon Sensor";
    homepage = "https://www.crowdstrike.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
