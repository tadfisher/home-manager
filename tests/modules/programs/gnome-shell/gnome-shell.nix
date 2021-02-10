{ config, lib, pkgs, ... }:

with lib;

let
  test-extension = pkgs.runCommand "test-extension" { } ''
    mkdir -p $out/share/gnome-shell/extensions/test-extension
    touch $out/share/gnome-shell/extensions/test-extension/test
  '';

  test-extension-uuid =
    pkgs.runCommand "test-extension-uuid" { uuid = "test-extension-uuid"; } ''
      mkdir -p $out/share/gnome-shell/extensions/test-extension-uuid
      touch $out/share/gnome-shell/extensions/test-extension-uuid/test
    '';

  test-theme = pkgs.runCommand "test-theme" { } ''
    mkdir -p $out/share/themes/Test/gnome-shell
    touch $out/share/themes/Test/gnome-shell/test
  '';

in {
  programs.gnome-shell.enable = true;

  programs.gnome-shell.extensions = [
    {
      id = "test-extension";
      package = test-extension;
    }
    { package = test-extension-uuid; }
  ];

  programs.gnome-shell.theme = {
    name = "Test";
    package = test-theme;
  };

  nmt.script = ''
    assertLinkPointsTo \
      home-files/.local/share/gnome-shell/extensions/test-extension \
      ${test-extension}/share/gnome-shell/extensions/test-extension

    assertLinkPointsTo \
      home-files/.local/share/gnome-shell/extensions/test-extension-uuid \
      ${test-extension-uuid}/share/gnome-shell/extensions/test-extension-uuid

    assertLinkPointsTo \
      home-files/.local/share/themes/Test/gnome-shell \
      ${test-theme}/share/themes/Test/gnome-shell
  '';
}
