{ config, lib, pkgs, ... }:
{
  imports = [ ./darwin/dock.nix ];
  
  home.username = "amberwing";
  home.homeDirectory = lib.mkForce "/Users/amberwing";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    dockutil # for managing persistent apps on dock
    pinentry_mac
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
      autohide = true;
      tilesize = 50;
    };
  };

  local.dock = {
    enable = true;
    entries = [
      { path = "/System/Applications/Apps.app"; }
      { path = "/Applications/Firefox.app"; }
      { path = "/System/Applications/Utilities/Terminal.app"; }
      { path = "/Applications/Obsidian.app"; }
      { path = "/Applications/Emacs.app"; }
      { path = "/Applications/Discord.app"; }
      { path = "/Applications/Thunderbird.app"; }

      {
        path = "~/Downloads/";
        section = "others";
        options = "--sort dateadded --view fan --display stack";
      }
    ];
  };
}
