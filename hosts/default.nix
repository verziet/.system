{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  options,
  host,
  hostname,
  ...
}: {
  # Modules
  grub.enableModule = lib.mkDefault true;
  hyprland.enableModule = lib.mkDefault true;
  gnome.enableModule = lib.mkDefault true;
  sddm.enableModule = lib.mkDefault true;
  bluetooth.enableModule = lib.mkDefault true;
  displaylink.enableModule = lib.mkDefault true;
  network.enableModule = lib.mkDefault true;
  nvidia.enableModule = lib.mkDefault true;
  pipewire.enableModule = lib.mkDefault true;
  firewall.enableModule = lib.mkDefault true;
  kanata.enableModule = lib.mkDefault true;
  ssh.enableModule = lib.mkDefault true;
  zsh.enableModule = lib.mkDefault true;

  # Essential packages
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
      nix-output-monitor # nom, cool dependency graphs, replacement for nix shell
      nvd # version diff tool
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

  networking.hostName = lib.mkDefault "${hostname}"; # Default hostname set to "hostname" defined in flake.nix

  # Nix settings
  nix.gc = {
    # Weekly garbage collection
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  nix = {
    channel.enable = lib.mkDefault false; # We use flakes already

    # make `nix run pkgs#package` use the same nixpkgs as the one used by this flake.
    registry = {
      pkgs.flake = lib.mkDefault inputs.nixpkgs;
      pkgs-stable.flake = lib.mkDefault inputs.nixpkgs-stable;
      pkgs-master.flake = lib.mkDefault inputs.nixpkgs-master;
    };

    settings = {
      experimental-features = lib.mkDefault ["flakes" "nix-command"];
      flake-registry = lib.mkDefault "";

      auto-optimise-store = true;

      # https://github.com/NixOS/nix/issues/9574
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
    };
  };

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  # Setting up users
  users = {
    defaultUserShell = lib.mkOverride 999 pkgs.zsh;

    users =
      lib.mapAttrs (username: _: {
        isNormalUser = lib.mkDefault true;

        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "input"
        ];
      })
      host.users;
  };

  # NTP
  networking.timeServers = options.networking.timeServers.default;

  # Imports
  imports = [
    ./${hostname}/configuration.nix
    ./${hostname}/packages.nix
    ./${hostname}/hardware.nix
    ../modules/nixos
  ];

  system.stateVersion = host.stateVersion;
}
