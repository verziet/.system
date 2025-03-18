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
      (pkgs.callPackage ../../pkgs/sddm-astronaut-theme.nix {
        theme = "japanese_aesthetic";
      })
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
