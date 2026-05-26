{ config, lib, pkgs, ... }:
{
  imports = [ ./../../modules/darwin/dock.nix ];
  
  home.username = "amberwing";
  home.homeDirectory = lib.mkForce "/Users/amberwing";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    emacs
    dockutil # for managing persistent apps on dock
    pinentry_mac
    obsidian
    localsend
    thunderbird
  ];

  programs = {
    gpg.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry_mac;
    };
  };

  targets.darwin.defaults = {
    "com.apple.dock" = {
      magnification = false;
      autohide = true;
      tilesize = 50;
    };
  };

  local.dock = {
    enable = true;
    entries = let
      hm = "~/Applications/Home Manager Apps";
    in [
      { path = "/System/Applications/Apps.app"; }
      { path = "/Applications/Firefox.app"; }
      { path = "/System/Applications/Utilities/Terminal.app"; }
      { path = "${hm}/Obsidian.app"; }
      { path = "${hm}/Emacs.app"; }
      { path = "/Applications/Discord.app"; }
      { path = "${hm}/Thunderbird.app"; }

      {
        path = "~/Downloads/";
        section = "others";
        options = "--sort dateadded --view fan --display stack";
      }
    ];
  };
}
