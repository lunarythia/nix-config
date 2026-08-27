{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.modules.theme.darkMode;
in {
  options.modules.theme.darkMode = {
    enable = mkEnableOption "";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
    dconf = {
      enable = lib.mkDefault true;
      settings."org/gnome/desktop/interface".color-scheme = lib.mkDefault "prefer-dark";
    };

    gtk = {
      enable = lib.mkDefault true;
      theme = {
        name = lib.mkDefault "Adwaita-dark";
        package = lib.mkDefault pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = lib.mkDefault true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = lib.mkDefault true;
      };
    };

    home.sessionVariables = {
      GTK_APPLICATION_PREFER_DARK_THEME = lib.mkDefault "1";

      GTK_USE_PORTAL = lib.mkDefault "1";
    };

    qt = {
      enable = lib.mkDefault true;
      platformTheme.name = lib.mkDefault "kde";
      style.name = lib.mkDefault "breeze-dark";
    };
    })

    (lib.mkIf (!cfg.enable) {
      dconf = {
        enable = lib.mkDefault true;
        settings."org/gnome/desktop/interface".color-scheme = lib.mkDefault "prefer-light";
      };

      gtk = {
        enable = lib.mkDefault true;
        theme = {
          name = lib.mkDefault "Adwaita";
          package = lib.mkDefault pkgs.gnome-themes-extra;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = lib.mkDefault false;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = lib.mkDefault false;
        };
      };

      home.sessionVariables = {
        GTK_APPLICATION_PREFER_DARK_THEME = lib.mkDefault "0";

        GTK_USE_PORTAL = lib.mkDefault "1";
      };

      qt = {
        enable = lib.mkDefault true;
        platformTheme.name = lib.mkDefault "kde";
        style.name = lib.mkDefault "breeze";
    };
    })
  ];
}
