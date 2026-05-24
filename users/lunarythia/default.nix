{ config, pkgs, ... }:
{
  users.users.lunarythia = {
  isNormalUser = true;
  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  packages = with pkgs; [
    tree
  ];
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9ENknBGbeJ9bDpVpbA5eWeMjC86D+HzVJVGrcdW346 lunarythiamaia@proton.me"
  ];
  };
 }