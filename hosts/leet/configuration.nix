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
  ];

  # Creating groups
  users.groups.uinput = {};

  # Setting up the uinput group, required for kanata
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  users.users = lib.genAttrs host.users (user: {
    extraGroups = ["uinput"];
  });

  programs.gamemode.enable = true;

  services.upower.enable = true;

  /*
  # tty1 autologin
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin verz --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  };
  */

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
