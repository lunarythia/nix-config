{
  fetchFromGitHub,
  glib,
  glib-networking,
  gobject-introspection,
  gtk3,
  ibus,
  lib,
  pkg-config,
  python3,
  python314Packages,
  python3Packages,
  stdenv,
  webkitgtk_4_1,
  wrapGAppsHook3
}:

python3Packages.buildPythonPackage rec {
  name = "keyman-config";
  version = "18.0.255";
  
  src = fetchFromGitHub {
    owner = "keymanapp";
    repo = "keyman";
    rev = "release@${version}";
    hash = "sha256-uzXd4P5tc6wqB/KbrWACwFGjOK3XtxEYjEN6IRsFDcc=";
    sparseCheckout = [
      "linux/keyman-config"
      "resources"
      "VERSION.md"
    ];
  };
  sourceRoot = "source/linux/keyman-config";
  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    gtk3
    glib
    glib-networking
    ibus
    webkitgtk_4_1
  ];
  propagatedBuildInputs = with python314Packages; [
    dbus-python
    fonttools
    lxml
    numpy
    packaging
    pillow
    pygobject3
    python-magic
    pyxdg
    qrcode
    requests-cache
    requests
    sentry-sdk
  ];

  pyproject = true;
  build-system = [ python314Packages.setuptools ];
  dontWrapGApps = true;
  preFixup = ''
  makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  KEYMAN_VERSION = version;
  KEYMAN_VERSION_WITH_TAG = version;
  KEYMAN_VERSION_GIT_TAG = src.rev;
  KEYMAN_VERSION_MAJOR = builtins.head (builtins.splitVersion version);
  KEYMAN_VERSION_RELEASE = KEYMAN_VERSION_MAJOR + ".0";
  KEYMAN_TIER = "stable";
  KEYMAN_VERSION_ENVIRONMENT = "stable";
  UPLOAD_SENTRY = "true";
  
  postPatch = ''
  pushd keyman_config
  sed \
      -e "s/_VERSION_/''${KEYMAN_VERSION}/g" \
      -e "s/_VERSIONWITHTAG_/''${KEYMAN_VERSION_WITH_TAG}/g" \
      -e "s/_VERSIONGITTAG_/''${KEYMAN_VERSION_GIT_TAG}/g" \
      -e "s/_MAJORVERSION_/''${KEYMAN_VERSION_MAJOR}/g" \
      -e "s/_RELEASEVERSION_/''${KEYMAN_VERSION_RELEASE}/g" \
      -e "s/_TIER_/''${KEYMAN_TIER}/g" \
      -e "s/_ENVIRONMENT_/''${KEYMAN_VERSION_ENVIRONMENT}/g" \
      -e "s/_UPLOADSENTRY_/''${UPLOAD_SENTRY}/g" \
      version.py.in > version.py
  popd

  pushd buildtools
  python3 ./build-langtags.py
  popd
  '';

  # in preparation for new version, in the future, replace above sed with below version:
  # sed \
  #     -e "s/__KEYMAN_VERSION__/''${KEYMAN_VERSION}/g" \
  #     -e "s/__KEYMAN_VERSION_WITH_TAG__/''${KEYMAN_VERSION_WITH_TAG}/g" \
  #     -e "s/__KEYMAN_VERSION_GIT_TAG__/''${KEYMAN_VERSION_GIT_TAG}/g" \
  #     -e "s/__KEYMAN_VERSION_MAJOR__/''${KEYMAN_VERSION_MAJOR}/g" \
  #     -e "s/__KEYMAN_VERSION_RELEASE__/''${KEYMAN_VERSION_RELEASE}/g" \
  #     -e "s/__KEYMAN_TIER__/''${KEYMAN_TIER}/g" \
  #     -e "s/__KEYMAN_VERSION_ENVIRONMENT__/''${KEYMAN_VERSION_ENVIRONMENT}/g" \
  #     -e "s/__UPLOAD_SENTRY__/''${UPLOAD_SENTRY}/g" \
  #     version.py.in > version.py

  postInstall = ''
  mkdir -p $out/share/glib-2.0/schemas
  cp resources/com.keyman.gschema.xml $out/share/glib-2.0/schemas
  glib-compile-schemas $out/share/glib-2.0/schemas
  '';
  
  meta = {
    description = "Keyman GUI config";
    homepage = "https://github.com/keymanapp/keyman";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ lunarythia ];
    platforms = lib.platforms.linux;
  };
}
