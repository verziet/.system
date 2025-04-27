{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  config,
  host,
  hostname,
  username,
  configuration,
  ...
}: {
  # Modules
  config.git.enableModules = lib.mkDefault true;
  config.hyprland.enableModules = lib.mkDefault true;
  config.ags.enableModules = lib.mkDefault true;
  config.nixcord.enableModules = lib.mkDefault true;
  config.nvf.enableModules = lib.mkDefault true;
  config.spicetify-nix.enableModules = lib.mkDefault true;
  config.starship.enableModules = lib.mkDefault true;
  config.zoxide.enableModules = lib.mkDefault true;
  config.zsh.enableModules = lib.mkDefault true;

  # Settings up home folder
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  # Nix settings
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # Imports
  imports =
    [
      ./${username}/home.nix
      ./${username}/packages.nix
      ../modules/home-manager
    ]
    ++ lib.optional (builtins.pathExists ./${username}/per-host/${hostname}.nix)
    ./${username}/per-host/${hostname}.nix;


  systemd.user.startServices = "sd-switch";

  home.stateVersion = host.stateVersion;
}