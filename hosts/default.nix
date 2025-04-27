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

  # Modules
  config.grub.enableModule = lib.mkDefault true;
  config.hyprland.enableModule = lib.mkDefault true;
  config.gnome.enableModule = lib.mkDefault true;
  config.sddm.enableModule = lib.mkDefault true;
  config.bluetooth.enableModule = lib.mkDefault true;
  config.displaylink.enableModule = lib.mkDefault true;
  config.network.enableModule = lib.mkDefault true;
  config.nvidia.enableModule = lib.mkDefault true;
  config.pipewire.enableModule = lib.mkDefault true;
  config.firewall.enableModule = lib.mkDefault true;
  config.kanata.enableModule = lib.mkDefault true;
  config.ssh.enableModule = lib.mkDefault true;
  config.zsh.enableModule = lib.mkDefault true;

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

      # Control utilities
      nmcli
      bluetoothctl
      wpctl
      brightnessctl
      acpi
      playerctl

      # Superior terminal
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

  networking.hostName = lib.mkDefault "${hostname}"; # Default hostname set to "hostname" defined in flake.nix

	# Nix settings
	nixpkgs.config.allowUnfree = lib.mkDefault true;

	nix = {
		channel.enable = lib.mkDefault false;

		# make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
		registry = {
			pkgs.flake = lib.mkDefault inputs.nixpkgs;
			pkgs-stable.flake = lib.mkDefault inputs.nixpkgs-stable;
			pkgs-master.flake = lib.mkDefault inputs.nixpkgs-master;
		};

		settings = {
			experimental-features = lib.mkDefault ["flakes" "nix-command"];
			flake-registry = lib.mkDefault "";

			# https://github.com/NixOS/nix/issues/9574
			nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

			substituters = lib.mkIf config.hyprland.enableModule (lib.mkDefault ["https://hyprland.cachix.org"]);
			trusted-public-keys = lib.mkIf config.hyprland.enableModule (lib.mkDefault ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="]);
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
        initialPassword = lib.mkDefault "${username}"; # Setting initial password to the username
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

  # Imports
  imports = [
    ./${hostname}/configuration.nix
    ./${hostname}/packages.nix
    ./${hostname}/hardware.nix
    ../modules/nixos
  ];

  system.stateVersion = host.stateVersion;
}