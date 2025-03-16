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
  environment.systemPackages = with pkgs; [
    # List of all your host specific packages
  ];
}
