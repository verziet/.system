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
  imports = [
    ./${username}/home.nix
    ./${username}/specific/${hostname}.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = host.stateVersion;
}
