{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    neofetch
  ];
}
