let
  cli = let
    p = ./cli;
  in [
    (p + "/git.nix")
  ];

  desktop = let
    p = ./desktop;
  in [
    (p + "/hyprland.nix")
  ];

  shell = let
    p = ./shell;
  in [
    (p + "/zsh.nix")
    (p + "/starship.nix")
    (p + "/zoxide.nix")
  ];

  programs = let
    p = ./programs;
  in [
    (p + "/ags.nix")
    (p + "/nixcord.nix")
    (p + "/nvf.nix")
    (p + "/spicetify-nix.nix")
    (p + "/textfox.nix")
  ];
in {
  imports = cli ++ desktop ++ shell ++ programs;
}
