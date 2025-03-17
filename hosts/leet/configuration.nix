{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  config,
  host,
  hostname,
  configuration,
  ...
}: {
  imports = [
    ../../modules/nixos/hardware/nvidia.nix

    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/gnome.nix

    ../../modules/nixos/services/kanata.nix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
