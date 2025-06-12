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
stdenv.mkDerivation {
  name = "falcon-sensor-unwrapped";
  version = "<version>";
  arch = "x86_64-linux";
  src = ./falcon-sensor_<version>.deb;

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
