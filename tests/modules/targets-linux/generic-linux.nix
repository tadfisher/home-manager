{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    targets.genericLinux.enable = true;

    nmt.script = ''
      envFile=home-files/.config/environment.d/10-home-manager.conf
      assertFileExists $envFile
      assertFileContains $envFile \
        'XDG_DATA_DIRS=''${NIX_STATE_DIR:-/nix/var/nix}/profiles/default/share:/home/hm-user/.nix-profile/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}'

      sessionVarsFile=home-path/etc/profile.d/hm-session-vars.sh
      assertFileExists $sessionVarsFile
      assertFileContains $sessionVarsFile \
        '. "${pkgs.nix}/etc/profile.d/nix.sh"'
    '';
  };
}
