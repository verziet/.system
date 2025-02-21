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

  home.packages = with pkgs;
    [
      firefox
      stremio
      mission-center
      libreoffice
      bottles
      lutris
      heroic
      google-chrome
      wineWowPackages.waylandFull
      protonvpn-gui
      ranger
      neovim
      wofi
      pavucontrol
      gnome-control-center

      hyprpanel
      swww
    ] ++ [
      pkgs-stable.protonmail-desktop
      pkgs-stable.proton-pass
    ]
    ++ [
      inputs.zen-browser.packages."${host.system}".default
    ];
}
