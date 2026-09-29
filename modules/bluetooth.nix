{ config, lib, pkgs, ... }:

let
  cfg = config.modules.bluetooth;
in {
  options.modules.bluetooth.enable = lib.mkEnableOption "Enable Bluetooth";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
