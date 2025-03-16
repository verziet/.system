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
  networking.hostName = lib.mkDefault hostname; # Default hostname set to "hostname" defined in flake.nix

  environment.systemPackages = with pkgs; [
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

    # Some control utilities
    brightnessctl
    playerctl
  ];

  # Setting up users
  users = {
    defaultUserShell = lib.mkOverride 999 pkgs.zsh;
    users = lib.genAttrs host.users (username: {
      initialPassword = lib.mkDefault username; # Setting initial password to the username
      isNormalUser = lib.mkDefault true;

      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "input"
      ];
    });
  };

  # Enable zsh, required for default user shell above
  programs.zsh.enable = lib.mkDefault true;

  imports = [
    # TODO temporary
    ../modules/nixos/bootloader.nix
    ../modules/nixos/nix.nix

    ../modules/nixos/hardware/network.nix
    ../modules/nixos/hardware/bluetooth.nix

    ./${hostname}/configuration.nix
    ./${hostname}/packages.nix
    ./${hostname}/hardware.nix
  ];

  system.stateVersion = host.stateVersion;
}
