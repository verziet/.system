{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  config,
	options,
  host,
  hostname,
  configuration,
  ...
}: {
  imports = [
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/nixos/hardware/displaylink.nix

    ../../modules/nixos/desktop/sddm.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/gnome.nix

    ../../modules/nixos/services/kanata.nix
  ];

	programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
		biome
  ];

	networking.timeServers = options.networking.timeServers.default;

	environment.sessionVariables = {
		NH_FLAKE = "/home/verz/.system/";
	};

  services.hardware.bolt.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";

  # Optionally (BEWARE: requires a different format with the added /UTF-8)
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8"];

  # Optionally
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8"; # This overrides all other LC_* settings.
  };
}
