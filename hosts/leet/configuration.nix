{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  config,
  host,
  hostname,
  ...
}: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    biome
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/home/verz/.system/";
  };

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
