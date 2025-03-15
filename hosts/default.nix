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
    ./${hostname}/configuration.nix
    ./${hostname}/packages.nix
    ./${hostname}/hardware.nix

    # TODO temporary
    ../modules/nixos/bootloader.nix
    ../modules/nixos/nix.nix

    ../modules/nixos/hardware/network.nix
    ../modules/nixos/hardware/bluetooth.nix
  ];

  services.xserver = {
    enable = lib.mkDefault true;
    exportConfiguration = lib.mkDefault true;

    displayManager.startx.enable = lib.mkDefault true;

    xkb = {
      layout = lib.mkDefault "us";
    };
  };

  console = {
    enable = lib.mkDefault true;
    useXkbConfig = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    # Basic text editors
    nano
    vim
    emacs-nox

    # Essentials
    home-manager
    git

    # Nix utilities
    nh # cooler nix-rebuild
    nix-output-monitor # nom, cool dependency graphs
    nvd # version diff tool

    kanata
    playerctl
    brightnessctl
    wireplumber
  ];

  # Enable Zsh. required for default user shell below
  programs.zsh.enable = true;

  # Setting up users
  users.defaultUserShell = pkgs.zsh;
  users.users = lib.genAttrs host.users (user: {
    initialPassword = user; # Setting initial password to the username
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "input"
      "uinput"
    ];
  });

  networking.hostName = lib.mkDefault hostname; # Default hostname set to "hostname" defined in flake.nix

  # Creating groups
  users.groups.uinput = {};

  # Setting up the uinput group, required for kanata
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  system.stateVersion = host.stateVersion;
}
