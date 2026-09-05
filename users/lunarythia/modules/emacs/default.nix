{ config, lib, pkgs, ... }:

let
  cfg = config.emacs;
in {
  options.emacs.enable = lib.mkEnableOption "Enable Emacs";

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs: with epkgs; [
        # https://mort.io/blog/treesitting-emacs/
        # https://wiki.nixos.org/wiki/Emacs
        (treesit-grammars.with-grammars (p: with p; [
          tree-sitter-kdl
        ]))
      ];
    };

    xdg.configFile = lib.genAttrs [ "ambermacs" "chemacs" "emacs" ] (subpath: {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/lunarythia/modules/emacs/${subpath}";
      recursive = true;
    });
  };
}
