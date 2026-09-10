{ config, lib, pkgs, ... }:

let
  cfg = config.modules.printing;
in {
  options.modules.printing.enable = lib.mkEnableOption "Enable printing and setup printers";

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        hplipWithPlugin
      ];
    };
    hardware.printers = {
      ensurePrinters = [
        {
          name = "HP_Color_LaserJet_CM1015_MFP";
          description = "HP Color LaserJet CM1015 MFP";
          location = "Garage";
          deviceUri = "socket://192.168.1.175:9101";
          model = "HP/hp-color_laserjet_cm1015-ps.ppd.gz";
        }
      ];
    };
  };
}
