{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."hyprland".enableModule = lib.mkOption {
    description = "Enable the hyprland module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."hyprland".enableModule {
    systemd.tmpfiles.rules = lib.concatMap (username: [
			''f+ /home/${username}/.config/uwsm/env - - - - export NIXOS_OZONE_WL=1\nexport QT_AUTO_SCREEN_SCALE_FACTOR=1\nexport QT_QPA_PLATFORM=wayland;xcb\nexport QT_WAYLAND_DISABLE_WINDOWDECORATION=1\nexport QT_QPA_PLATFORMTHEME=qt5ct''
			#TODO (lib.optional (config.nvidia.enableModule) ''w+ /home/${username}/.config/uwsm/env - - - - export GBM_BACKEND=nvidia-drm\nexport __GLX_VENDOR_LIBRRY_NAME=nvidia\nexport LIBVA_DRIVER_NAME=nvidia'')
		]) (lib.attrNames host.users);

    programs.uwsm.enable = lib.mkForce true;

    programs.hyprland = {
      enable = lib.mkForce true;
      withUWSM = lib.mkForce true;
      xwayland.enable = lib.mkDefault true;

      package = lib.mkDefault inputs.hyprland.packages.${host.system}.hyprland;
      portalPackage = lib.mkDefault inputs.hyprland.packages.${host.system}.xdg-desktop-portal-hyprland;
    };
  };
}
