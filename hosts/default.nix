{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  lib,
  host,
  hostname,
  configuration,
  ...
}: {
  imports = [
    ./${hostname}/configuration.nix
    ./${hostname}/hardware.nix

    # TODO temporary
    ../modules/nixos/bootloader/grub.nix
    ../modules/nixos/hardware/bluetooth.nix
    ../modules/nixos/nix/nixpkgs.nix
  ];

  # Enable grub
  grub.enable = true;

  services.xserver = {
  xkb.layout = "us,cs";
  xkb.options = "grp:win_space_toggle";
};

  nix = {
      channel.enable = false;

      settings = {
	experimental-features = ["flakes" "nix-command"];

	substituters = ["https://hyprland.cachix.org"];
    	trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
  /*
  nix = {
    channel.enable = false; # Channels are pointless with flakes enabled
    settings.experimental-features = ["flakes" "nix-command"]; # Enable flakes and nix commands
  };
*/

  /*
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  */
  nixpkgs.enable = true;

  environment.systemPackages = with pkgs; [
    # Basic text editors
    nano
    vim
    emacs-nox

    # Essentials
    home-manager
    git
  ];

  /*
     #TODO experimenting
  # Runs on every system rebuild
  systemd.services.createTmpfiles = {
    description = "Creates tmpfiles files after every NixOS rebuild";
    wantedBy = ["multi-user.target"];
    before = ["nixos-rebuild.service"];

    serviceConfig = {
      ExecStart = ''${pkgs.systemd}/bin/systemd-tmpfiles --create'';
      Restart = "no";
      Type = "oneshot";
    };
  };

  # Declarative folders & files #TODO gotta fix path later (/etc/nixos)
  systemd.tmpfiles.rules =
    lib.concatMap (user: [
      # Creating folder for each user
      ''f /etc/nixos/users/${user}/home.nix - - - - {}'' # Common home configuration file
    ])
    (lib.unique (lib.concatMap (host: host.users) (lib.attrValues configuration.hosts)))
    ++
    lib.concatMap (hostname: [
      # Creating folder for each host
      # Default configuration files #TODO
      ''f /etc/nixos/hosts/${hostname}/configuration.nix - - - - # Define your configuration.nix options here\n{}''
      ''f /etc/nixos/hosts/${hostname}/hardware.nix - - - - # Put your generated hardware configuration here\n# TODO ill make a command that does that later\n{}''
      ]
      ++
      lib.concatMap (user: [
        ''f /etc/nixos/users/${user}/extended/${hostname}.nix - - - - {}'' # Extended home configuration file
      ]) configuration.hosts.${hostname}.users
     ) (lib.attrNames configuration.hosts);
  */

  # Enable Zsh. required for default user shell below
  programs.zsh.enable = true;

  # Setting up users
  users.defaultUserShell = pkgs.zsh;
  users.users = lib.genAttrs host.users (user: {
    initialPassword = user; # Setting initial password to the username
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "input"
      "uinput"
    ];
  });

  networking = {
    hostName = lib.mkDefault hostname; # Default hostname set to "host" defined in flake.nix
    networkmanager.enable = true; # Please let me connect to wifi :)
  };

  # Audio/pipewire configuration
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  bluetooth.enable = true;
  /*
  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  }; 

  # Enable Blueman
  services.blueman.enable = true; # Please let me connect to a bluetooth device :)
  */


  # Creating groups
  users.groups.uinput = {};

  # Setting up the uinput group, required for kanata
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Kanata service
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          # Use `ls /dev/input/by-path/` to find your keyboard devices.
          # Not needed, no device specific configuration YET
        ];

        extraDefCfg = "process-unmapped-keys yes";
/*
(defalias
  Ae (unicode Ä)
  Ue (unicode Ü)
  Oe (unicode Ö)
  ae (unicode ä)
  ue (unicode ü)
  oe (unicode ö)
  _ae (fork @ae @Ae (lsft rsft))
  _ue (fork @ue @Ue (lsft rsft))
  _oe (fork @oe @Oe (lsft rsft))
)
*/
        config = ''
                 (defsrc
                   caps a s d f h j k l ; u i n m spc
		   2 3 4 5 6 7 8 9 0
                 )

          (defvar
            tap-time 200
            hold-time 200
          )

          (defalias
            caps (tap-hold 100 100 esc (layer-toggle caps))
            space (tap-hold 200 200 spc (layer-toggle space))
            a (tap-hold $tap-time $hold-time a lmet)
            s (tap-hold $tap-time $hold-time s lalt)
            d (tap-hold $tap-time $hold-time d lsft)
            f (tap-hold $tap-time $hold-time f lctl)
            j (tap-hold $tap-time $hold-time j rctl)
            k (tap-hold $tap-time $hold-time k rsft)
            l (tap-hold $tap-time $hold-time l ralt)
            ; (tap-hold $tap-time $hold-time ; rmet)
  	    ě (fork (unicode ě) (unicode Ě) (lsft rsft))
  	    š (fork (unicode š) (unicode Š) (lsft rsft))
  	    č (fork (unicode č) (unicode Č) (lsft rsft))
  	    ř (fork (unicode ř) (unicode Ř) (lsft rsft))
  	    ž (fork (unicode ž) (unicode Ž) (lsft rsft))
  	    ý (fork (unicode ý) (unicode Ý) (lsft rsft))
  	    á (fork (unicode á) (unicode Á) (lsft rsft))
  	    í (fork (unicode í) (unicode Í) (lsft rsft))
  	    é (fork (unicode é) (unicode É) (lsft rsft))
          )

          (deflayer base
            @caps @a @s @d @f h @j @k @l @; _ _ _ _ @space
 	    _ _ _ _ _ _ _ _ _
          )

                 (deflayer caps
            _ _ _ _ _ left down up right _ home end bspc del enter
 	    _ _ _ _ _ _ _ _ _
                 )

                 (deflayer space
            _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	    @ě @š @č @ř @ž @ý @á @í @é
                 )
        '';
      };
    };
  };

system.stateVersion = host.stateVersion;
}
