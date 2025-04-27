# empty for now
{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  host,
  hostname,
  username,
  configuration,
  ...
}: {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.image = ../../wallpaper.png;
  stylix.polarity = "dark";
  stylix.targets.hyprland.enable = false;
  stylix.targets.kitty.enable = false;
  stylix.targets.hyprlock.enable = false;
  stylix.targets.fuzzel.enable = false;
  #stylix.targets.spicetify.enable = false;
  #stylix.targets.nixcord.enable = false;
  stylix.targets.firefox.profileNames = [username];

  xdg.desktopEntries = {
    control-center = {
      name = "Control Center";
      genericName = "Control Center";
      type = "Application";
      exec = "env XDG_CURRENT_DESKTOP=GNOME ${pkgs.gnome-control-center}/bin/gnome-control-center";
      terminal = false;
      categories = ["Application"];
    };
  };
}
