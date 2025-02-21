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
  imports = [
    ./packages.nix
  ];

  stylix.enable = true;
  stylix.image = ../../lion.png;
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  # nvidia
  services.xserver.videoDrivers = ["nvidia"];

  xdg.portal.wlr.enable = true;
  services.dbus.enable = true;

  programs.gamemode.enable = true;

  hardware = let
    pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${host.system};
  in {
    graphics = {
      enable = true;
      enable32Bit = true;

      package = pkgs-hyprland.mesa.drivers;
      package32 = pkgs-hyprland.pkgsi686Linux.mesa.drivers;
    };

    nvidia = {
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };

  services.upower.enable = true;
  grub.timeout = 1;

  # In your NixOS configuration file
networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 22 ]; # Allow SSH
};

  services.openssh = {
  enable = true;
  # Optional: Permit root login (not recommended)
  # settings.PermitRootLogin = "no";
};

  # tty1 autologin
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin verz --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;

    package = inputs.hyprland.packages.${host.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${host.system}.xdg-desktop-portal-hyprland;
  };
}
