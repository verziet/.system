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
  environment.systemPackages = with pkgs;
    [
      # List of all your host specific unstable packages
    ]
    ++ (with pkgs-stable; [
      # List of all your host specific stable packages
    ])
    ++ (with pkgs-master; [
      # List of all your host specific master packages
    ]);
}
