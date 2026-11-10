{
  cmake,
  fcitx5,
  fetchFromGitHub,
  gettext,
  kdePackages,
  keyman-core,
  lib,
  nlohmann_json,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-keyman";
  version = "1.1.6";
  
  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-xb0Jfn5oswotwYCUibp3V/7VI1U2Q/O/n6ruH/k9H5w=";
  };
  buildInputs = [
    fcitx5
    keyman-core
  ];
  nativeBuildInputs = [
    cmake
    gettext
    kdePackages.extra-cmake-modules
    nlohmann_json
    pkg-config
  ];

  meta = {
    description = "Keyman integration for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-keyman";
    license = lib.licenses.gpl2Plus;
    # maintainers = with lib.maintainers; [ lunarythia ];
    platforms = lib.platforms.linux;
  };
}
