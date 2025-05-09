{
  pkgs,
  lib,
  config,
  ...
}: {
  options."grub".enableModule = lib.mkOption {
    description = "Enable the grub module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."grub".enableModule {
    boot.loader = {
      timeout = lib.mkDefault null;
      efi.canTouchEfiVariables = lib.mkDefault true;

      grub = let
        extraEntries = ''
          menuentry "Reboot" --class restart {
          	reboot
          }

          menuentry "Shutdown" --class shutdown {
          	halt
          }
        '';
      in {
        enable = lib.mkForce true;
        configurationLimit = lib.mkDefault 10;
        theme = lib.mkDefault pkgs.minimal-grub-theme;

        useOSProber = lib.mkDefault true;
        efiSupport = lib.mkDefault true;
        device = lib.mkDefault "nodev";

        backgroundColor = lib.mkDefault "#000000";
        splashImage = lib.mkOverride 999 null;

        extraInstallCommands = lib.mkDefault ''
          echo "${extraEntries}" >> /boot/grub/grub.cfg
        '';
      };
    };
  };
}
