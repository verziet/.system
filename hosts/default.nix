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
  networking.hostName = lib.mkDefault "${hostname}"; # Default hostname set to "hostname" defined in flake.nix

  environment.systemPackages = with pkgs;
    [
      # Basic text editors
      nano
      vim
      emacs-nox

      # Essentials
      home-manager
      git

      # Nix utilities
      nh # nix helper
      nix-output-monitor # nom, cool dependency graphs
      nvd # version diff tool

      # Some controls utilities
      brightnessctl
      playerctl

      # kitty is superior
      kitty
    ]
    ++ (with pkgs-stable; [
      #
    ])
    ++ (with pkgs-master; [
      #
    ])
    ++ [
      #
    ];

  # Setting up users
  users = {
    defaultUserShell = lib.mkOverride 999 pkgs.zsh;

    users = lib.genAttrs host.users (username: {
      initialPassword = lib.mkDefault "${username}"; # Setting initial password to the username
      isNormalUser = lib.mkDefault true;

      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "input"
      ];
    });
  };

  imports = [
    # TODO
    ../modules/nixos/bootloader/grub.nix
    ../modules/nixos/nix.nix

    ../modules/nixos/hardware/network.nix
    ../modules/nixos/hardware/pipewire.nix
    ../modules/nixos/hardware/bluetooth.nix

    ../modules/nixos/services/firewall.nix
    ../modules/nixos/services/ssh.nix

    ../modules/nixos/shell/zsh.nix

    ./${hostname}/configuration.nix
    ./${hostname}/packages.nix
    ./${hostname}/hardware.nix
  ];

  system.stateVersion = host.stateVersion;
}
