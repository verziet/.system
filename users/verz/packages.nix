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
  home.packages = with pkgs;
    [
      neovim
      ranger
      wofi

      stremio
      libreoffice
      protonvpn-gui
      heroic

      pavucontrol
      gnome-control-center
      mission-center

      swww
      kanata
    ]
    ++ (with pkgs-stable; [
      protonmail-desktop
      proton-pass
    ])
    ++ (with pkgs-master; [
      #
    ])
    ++ [
      inputs.zen-browser.packages."${host.system}".default
    ];
}
