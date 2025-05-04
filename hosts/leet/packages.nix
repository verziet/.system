{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      #
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
