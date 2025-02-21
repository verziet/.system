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

  programs.xwayland.enable = true;

  services.xserver = {
    enable = true;
    exportConfiguration = true;

    displayManager.startx.enable = true;

    xkb = {
      layout = "us,cz";
      variant = ",qwerty";
      options = "grp:win_space_toggle";
    };
  };

  console = {
    enable = true;
    useXkbConfig = true;
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

  environment.sessionVariables = {
    FLAKE = "${inputs.self.outPath}";
  };

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

    # Nix utilities
    nh # cooler nix-rebuild
    nix-output-monitor # nom, cool dependency graphs
    nvd # version diff tool
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
                 1 2 3 4 5 6 7 8 9 0 -
                 u i
                 caps a s d f h j k l ;
                 n m
                 spc
               )

               (deftemplate charmod (char mod)
                 (switch
                   ((key-timing 3 less-than 250)) $char break
                   () (tap-hold-release-timeout 200 500 $char $mod $char) break
                 )
               )

               (deflayermap (base)
                 caps esc
		 
                 ;; home row mods
                 a (t! charmod a lmet)
                 s (t! charmod s lalt)
                 d (t! charmod d lsft)
                 f (t! charmod f rctl)

                 j (t! charmod j rctl)
                 k (t! charmod k rsft)
                 l (t! charmod l ralt)
                 ; (t! charmod ; rmet)

                 spc (t! charmod spc (layer-toggle space-held))
               )

               (deflayermap (space-held)
	         ;; czech symbols
		 1 (macro A-spc ; A-spc)
		 2 (macro A-spc Digit2 A-spc)
		 3 (macro A-spc Digit3 A-spc)
		 4 (macro A-spc Digit4 A-spc)
		 5 (macro A-spc Digit5 A-spc)
		 6 (macro A-spc Digit6 A-spc)
		 7 (macro A-spc Digit8 A-spc)
		 8 (macro A-spc Digit8 A-spc)
		 9 (macro A-spc Digit9 A-spc)
		 0 (macro A-spc Digit0 A-spc)
		 - (macro A-spc [ A-spc)

                 u home
		 i end

                 h left
		 j down
		 k up
		 l right

                 n bspc
		 m del
               )
        '';
      };
    };
  };

  system.stateVersion = host.stateVersion;
}
