{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.pltanton ];

  options = {
    services.pasystray = {
      enable = mkEnableOption "PulseAudio system tray";
    };
  };

  config = mkIf config.services.pasystray.enable {
    systemd.user.services.pasystray = {
        Unit = {
          Description = "PulseAudio system tray";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.pasystray}/bin/pasystray";
        };
    };
  };
}