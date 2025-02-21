{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  options."grub" = {
    enable = lib.mkEnableOption {
      default = false;
      description = "Enable the GRUB bootloader";
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 20;
      description = "Sets the GRUB bootloader timeout";
    };

    enableTheming = lib.mkEnableOption {
      default = false;
      description = "Enable the GRUB bootloader theming";
    };
  };

  config = lib.mkIf config."grub".enable {
    /*
    imports = lib.mkIf config."grub".enableTheming [
      inputs.grub2-themes.nixosModules.default
    ];
    */
    boot.loader = {
      timeout = config."grub".timeout;
      efi.canTouchEfiVariables = true;

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
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";

        #backgroundColor = "#000000";
        #splashImage = null;

        extraInstallCommands = ''echo "${extraEntries}" >> /boot/grub/grub.cfg'';
      };

      /*
      grub2-theme = lib.mkIf config."grub".enableTheming {
        enable = true;
        theme = "vimix";
        footer = true;
      };
      */
    };
  };
}
