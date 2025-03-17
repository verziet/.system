{
  description = ''
    My super duper flake.nix file
  ''; #TODO

  # Flake outputs
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-master,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    #FIXME Change the configuration to your liking
    configuration = {
      # List of all hosts with their respective settings
      hosts = {
        "leet" = {
          system = "x86_64-linux"; # System architecture, one of the supported systems defined below
          stateVersion = "24.11"; # Should match the iso's version for compatibility

          # List of host's users
          users = [
            "verz"
            "verz2"
            # Add more users if desired
          ];
        };

        # Add more hosts if desired
      };
    };

    homeManagerModules = [
      inputs.textfox.homeManagerModules.default
      inputs.nixcord.homeManagerModules.nixcord
      inputs.spicetify-nix.homeManagerModules.default
    ];

    # List of all supported systems
    supportedSystems = {
      linux = [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
      ];

      mac = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };

    inherit (nixpkgs) lib; # shorthand for nixpkgs.lib
    inherit (self) outputs; # shorthand for self.outputs

    forAllSystems = lib.genAttrs (lib.concatLists (lib.attrValues supportedSystems));
  in {
    # Creating multiple nixos configurations using the hosts set, to select one during install/rebuild: --flake path#hostname
    nixosConfigurations = lib.mapAttrs (
      hostname: host:
        lib.nixosSystem {
          system = host.system;
          modules = [./hosts];

          # Stuff passed to modules as inputs/arguments
          specialArgs = {
            # pkgs passed by default
            pkgs-stable = nixpkgs-stable.legacyPackages.${host.system};
            pkgs-master = nixpkgs-master.legacyPackages.${host.system};
            inherit inputs host hostname configuration;
          };
        }
    ) (lib.attrsets.filterAttrs (_: host: lib.elem host.system supportedSystems."linux") configuration.hosts);
    # ^ nixosConfigurations output set for linux hosts

    # I'm not sure whether this works
    # Creating multiple darwin (macos) configurations using the hosts set, to select one: --flake path#hostname
    darwinConfigurations = lib.mapAttrs (
      hostname: host:
        nix-darwin.lib.darwinSystem {
          system = host.system;
          modules = [./hosts];

          # Stuff passed to modules as inputs/arguments
          specialArgs = {
            # pkgs passed by default
            pkgs-stable = nixpkgs-stable.legacyPackages.${host.system};
            pkgs-master = nixpkgs-master.legacyPackages.${host.system};
            inherit inputs host hostname configuration;
          };
        }
    ) (lib.attrsets.filterAttrs (_: host: lib.elem host.system supportedSystems."mac") configuration.hosts);
    # ^ darwinConfigurations output set for mac hosts

    # Creating multiple home configurations using the users lists while looping through hosts
    homeConfigurations =
      lib.attrsets.foldlAttrs (
        _acc: hostname: host:
          lib.foldl (
            _acc2: username:
              _acc2
              // {
                "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
                  pkgs = nixpkgs.legacyPackages.${host.system};
                  modules = [
                    ./users
                    {imports = homeManagerModules;}
                  ];

                  # Stuff passed to modules as inputs/arguments
                  extraSpecialArgs = {
                    # pkgs passed by default
                    pkgs-stable = nixpkgs-stable.legacyPackages.${host.system};
                    pkgs-master = nixpkgs-master.legacyPackages.${host.system};
                    inherit inputs host hostname username configuration;
                  };
                };
              }
          )
          _acc
          host.users
      ) {}
      configuration.hosts;

    # Most popular formatter, use with nix fmt
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; # Unstable branch, used as default (ily Arch <3)
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.11"; # stable branch
    nixpkgs-master.url = "github:nixos/nixpkgs?ref=master"; # Master branch (extreme rolling release), won't ever use this (i think)

    # Darwin (macos) configurations flake
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager configurations flake
    home-manager = {
      url = "https://github.com/nix-community/home-manager/archive/master.tar.gz"; # Unstable home-manager branch
      # url = "https://flakehub.com/f/nix-community/home-manager/*.tar.gz";
      # ^ latest stable home-manager, use in case of any problems (very unlikely, here as a fallback)
      # ^ might also cause problems, requires flake.lock update sometimes

      inputs.nixpkgs.follows = "nixpkgs"; # Would dupe nixpkgs otherwise (more storage eaten)
    };

    # Hyprland from source flake
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Widgets flake
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox theme flake
    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative spotify plugins with spicetify flake
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative discord plugins with vencord flake
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen browser flake (package doesn't exist yet) # TODO might just main firefox instead
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
