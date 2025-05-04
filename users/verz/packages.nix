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
      ranger
      dconf
      hyprshot
      google-chrome
      chromium

      vscode
      stremio
      libreoffice
      protonvpn-gui
      heroic

      pavucontrol
      gnome-control-center
      mission-center

      swww
      kanata
      kitty

      nodejs
      nodePackages.pnpm

      btop
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
