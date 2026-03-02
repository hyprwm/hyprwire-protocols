{
  lib,
  stdenv,
  cmake,
  version,
}:
stdenv.mkDerivation {
  pname = "hyprwire-protocols";
  inherit version;

  src = ../.;

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/hyprwm/hyprwire-protocols";
    description = "A centralized protocol spec repository for hyprwire/hyprtavern protocols";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
