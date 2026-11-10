{
  cmake,
  fetchFromGitHub,
  icu,
  lib,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv
}:

stdenv.mkDerivation rec {
  pname = "keyman-core";
  version = "18.0.255";
  
  src = fetchFromGitHub {
    owner = "keymanapp";
    repo = "keyman";
    rev = "release@${version}";
    hash = "sha256-WwnqTVCniTBsr9d/XWxgLhikhZ2fEKCF0JMz48y4nng=";
    sparseCheckout = [
      "common"
      "core"
      "resources"
      "VERSION.md"
    ];
  };
  sourceRoot = "source/core";

  dontUseCmakeConfigure = true;
  dontUseCmakeBuild = true;
  mesonFlags = [
    "-Dkeyman_core_tests=false"
  ];
  buildInputs = [ icu ];
  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
    python3
  ];

  postPatch = ''
  mkdir -p resources
  ln -s "$PWD/../resources/build/meson/standard.meson.build" ./resources/meson.build

  chmod +x getversion.sh
  patchShebangs getversion.sh
  '';

  
  meta = {
    description = "Keyman core";
    homepage = "https://github.com/keymanapp/keyman";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ lunarythia ];
    platforms = lib.platforms.linux;
  };
}
