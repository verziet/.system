{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,

  lib,

  host,
  hostname,
  username,
  configuration,
  ...
}: {
  nixpkgs.overlays = [
    inputs.hyprpanel.overlay
  ];

  home.packages = with pkgs; [
    firefox
    legcord
    stremio
    proton-pass
    mission-center
    libreoffice
    godot_4-mono
    ranger
    neovim
    wofi
    pavucontrol
    gnome-control-center

    hyprpanel
    swww
  ] ++ [
    inputs.zen-browser.packages."${host.system}".default
  ];
}  
