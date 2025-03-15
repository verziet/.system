{
  pkgs,
  lib,
  config,
  ...
}: {
  options."bootloader".enableModule = lib.mkOption {
    description = "Enable the bootloader module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."bootloader".enableModule {
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
        theme = lib.mkDefault pkgs.minimal-grub-theme;

        enable = lib.mkForce true;
        useOSProber = lib.mkDefault true;
        efiSupport = lib.mkDefault true;
        device = lib.mkDefault "nodev";

        backgroundColor = lib.mkDefault "#000000";
        splashImage = lib.mkForce null;

        extraInstallCommands = lib.mkDefault ''echo "${extraEntries}" >> /boot/grub/grub.cfg'';
      };
    };
  };
}
