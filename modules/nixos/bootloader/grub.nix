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
          menuentry 'Windows' --class windows --class os $menuentry_id_option 'osprober-efi-2275-5F7C' {
          	insmod part_gpt
          	insmod fat
          	search --no-floppy --fs-uuid --set=root 2275-5F7C
          	chainloader /efi/Microsoft/Boot/bootmgfw.efi
          }

					menuentry "Reboot" --class restart {
						reboot
					}

					menuentry "Shutdown" --class shutdown {
						halt
					}
        '';
      in {
        enable = lib.mkForce true;
        theme = lib.mkDefault pkgs.minimal-grub-theme;

        useOSProber = lib.mkDefault false;
        efiSupport = lib.mkDefault true;
        device = lib.mkDefault "nodev";

        backgroundColor = lib.mkDefault "#000000";
        splashImage = lib.mkOverride 999 null;

        extraInstallCommands = lib.mkDefault ''
          echo "${extraEntries}" >> /boot/grub/grub.cfg
        ''; # TODO rename Windows entries
      };
    };
  };
}
