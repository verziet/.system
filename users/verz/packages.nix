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
      ticktick
      google-chrome
      wineWowPackages.waylandFull
      protonvpn-gui
      ranger
      neovim
      wofi
      pavucontrol
      gnome-control-center

      swww

      /*
        #ags
         ollama
      pywal
      sassc
      (python311.withPackages (p: [
        p.material-color-utilities
        p.pywayland
      ]))
      */
    ]
    ++ [
      pkgs-stable.protonmail-desktop
      pkgs-stable.proton-pass
    ]
    ++ [
      inputs.zen-browser.packages."${host.system}".default
    ];
}
