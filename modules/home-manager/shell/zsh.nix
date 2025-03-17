{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."zsh".enableModule = lib.mkOption {
    description = "Enable the zsh module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."zsh".enableModule {
    programs.zsh = {
      enable = lib.mkForce true;

      enableCompletion = lib.mkDefault true;
      autosuggestion.enable = lib.mkDefault true;
      syntaxHighlighting.enable = lib.mkDefault true;

      envExtra = lib.mkDefault ''
        EDITOR=vim
      '';

      shellAliases = lib.mkDefault {
        l = "ls -l";
        ll = "ls -la";

        # TODO temporary
        hyprland = "exec uwsm start hyprland-uwsm.desktop";
        gnome = "XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session";
      };

      initExtra = ''
        bindkey "^H" backward-kill-word
        bindkey "5~" kill-word
      '';

      history = {
        extended = lib.mkDefault true;
        path = lib.mkDefault "${config.xdg.dataHome}/zsh/history";
        size = lib.mkDefault 10000;
      };
    };
  };
}
