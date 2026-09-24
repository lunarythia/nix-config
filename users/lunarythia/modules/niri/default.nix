{ config, lib, pkgs, ... }:

let
  cfg = config.luna.niri;
in {
  options.luna.niri.enable = lib.mkEnableOption "Enable Niri";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi
      wlogout
      waybar
    ];

    xdg.configFile = lib.genAttrs [ "niri" "rofi" "waybar" "wlogout" ] (subpath: {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/lunarythia/modules/niri/${subpath}";
      recursive = true;
    });
  };
}
