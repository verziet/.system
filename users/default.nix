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
  imports = [
    ./${username}/home.nix
  ] ++ lib.optional (builtins.pathExists ./${username}/per-host/${hostname}.nix)
    ./${username}/per-host/${hostname}.nix;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        l = "ls -l";
        ll = "ls -la";
      };

      history = {
        path = "${config.xdg.dataHome}/zsh/history";
        size = 10000;
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = host.stateVersion;
}
