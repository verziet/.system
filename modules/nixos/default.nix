let
  hardware = let
    p = ./hardware;
  in [
    (p + "/network.nix")
    (p + "/pipewire.nix")
    (p + "/bluetooth.nix")
    (p + "/displaylink.nix")
    (p + "/nvidia.nix")
  ];

  bootloader = let
    p = ./bootloader;
  in [
    (p + "/grub.nix")
  ];

  services = let
    p = ./services;
  in [
    (p + "/firewall.nix")
    (p + "/ssh.nix")
    (p + "/kanata.nix")
  ];

  shell = let
    p = ./shell;
  in [
    (p + "/zsh.nix")
  ];

  desktop = let
    p = ./desktop;
  in [
    (p + "/sddm.nix")
    (p + "/hyprland.nix")
    (p + "/gnome.nix")
  ];
in {
  imports = hardware ++ bootloader ++ services ++ shell ++ desktop;
}
