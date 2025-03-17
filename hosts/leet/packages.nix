{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      neofetch
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
}
