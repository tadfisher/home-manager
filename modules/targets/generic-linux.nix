{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.targets.genericLinux;

  profileDirectory = config.home.profileDirectory;

in {
  imports = [
    (mkRenamedOptionModule [ "targets" "genericLinux" "extraXdgDataDirs" ] [
      "xdg"
      "systemDirs"
      "data"
    ])
  ];

  options.targets.genericLinux = {
    enable = mkEnableOption "" // {
      description = ''
        Whether to enable settings that make Home Manager work better on
        GNU/Linux distributions other than NixOS.
      '';
    };
  };

  config = mkIf cfg.enable {
    xdg.systemDirs.data = let
      profiles =
        [ "\${NIX_STATE_DIR:-/nix/var/nix}/profiles/default" profileDirectory ];
    in map (profile: "${profile}/share") profiles;

    home.sessionVariablesExtra = ''
      . "${pkgs.nix}/etc/profile.d/nix.sh"
    '';

    # We need to source both nix.sh and hm-session-vars.sh as noted in
    # https://github.com/nix-community/home-manager/pull/797#issuecomment-544783247
    programs.bash.initExtra = ''
      . "${pkgs.nix}/etc/profile.d/nix.sh"
      . "${profileDirectory}/etc/profile.d/hm-session-vars.sh"
    '';

    systemd.user.sessionVariables = {
      NIX_PATH = "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
    };
  };
}
