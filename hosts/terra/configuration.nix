# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../users/lunarythia/default.nix

      inputs.aagl.nixosModules.default
    ];

  # Use the GRUB 2 boot loader.
  #  boot.loader.grub.enable = true;
  #  boot.loader.grub.efi.canTouchEfiVariables = false;
  #  boot.loader.grub.efiSupport = true;
  #  boot.loader.grub.efiInstallAsRemovable = true;
  #  boot.loader.efi.efiSysMountPoint = "/boot";
  # Define on which hard drive you want to install Grub.
  #  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  boot = {
    loader = {
	    efi.efiSysMountPoint = "/efi";
	    efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        copyKernels = true;
        useOSProber = true;
      };
    };
    kernelParams = [
      "intel_idle.max_cstate=2"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware.enableAllFirmware = true;

  networking.hostName = "terra-nix"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.displayManager.ly.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "01-always-process" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                { "node.name" = "~alsa_input.*"; }
              ];
              actions = {
                update-props = {
                  "node.always-process"             = true;
                };
              };
            }
          ];
        };
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  nix = {
    optimise = {
      automatic = true;
      dates = "weekly";
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];

      substituters = [ "https://ezkea.cachix.org" ];
      trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
    };
  };
  
  programs = {
	  hyprland = {
		  enable = true;
		  xwayland.enable = true;
	  };
    niri.enable = true;
    noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
    anime-game-launcher.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    (bottles.override { removeWarningPopup = true; })
    nvd
    vim-full # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nixd # lsp server for Nix
    wget
    git
    kitty
    thunar
    thunar-archive-plugin

    brightnessctl
    wlogout

    xwayland-satellite
    sof-firmware
    alsa-utils
    qt6.qtwayland
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-chewing
        fcitx5-gtk
      ];
      waylandFrontend = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    authorizedKeysInHomedir = true;
    settings.PasswordAuthentication = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # https://wiki.nixos.org/wiki/NVIDIA
  hardware.graphics.enable = true;
  
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    open = true;
    prime = {
      offload.enable = true;
      
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
      # amdgpuBusId = "PCI:5@0:0:0"; # If you have an AMD iGPU
    };
    modesetting.enable = true;
  };

  
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}

