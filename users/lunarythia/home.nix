{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nix-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    ambermacs = "ambermacs";
    chemacs = "chemacs";
    emacs = "emacs";
    kitty = "kitty";
    hypr = "hypr";
    rofi = "rofi";
    waybar = "waybar";
}; in {
  imports = [
    ./modules
  ];
  
    home.username = "lunarythia";
    home.homeDirectory = "/home/lunarythia";
    home.stateVersion = "25.11";
    programs.bash = {
	enable = true;
	shellAliases = {
            meow = "echo meow meow meow :3";
        };
	sessionVariables = {
	    GPG_TTY = "$(tty)";
	};
        initExtra = ''
        PS1='\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] '
        '';
    };

    home.packages = with pkgs; [
        pinentry-gnome3
	gcr # required for pinentry-gnome3

	emacs
	kdePackages.kate
	keepassxc
	rofi

	# fonts
        noto-fonts
        fira-code
        paratype-pt-sans
        roboto-slab
    ];

    programs = {
      firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
	git = {
	    enable = true;
	    settings = {
	    	     user.name = "lunarythia";
		     user.email = "63614345+lunarythia@users.noreply.github.com";
	    };
	};
	home-manager.enable = true;
	waybar.enable = true;

	gpg.enable = true;
    };

    home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ"; 

    services = {
	hyprpaper.enable = true;
	gpg-agent = {
	      enable = true;
	      pinentry.package = pkgs.pinentry-gnome3;
	};
    };
    
    xdg.configFile = builtins.mapAttrs (name: subpath: {
	source = create_symlink "${dotfiles}/${subpath}";
	recursive = true;
    }) configs;
}

