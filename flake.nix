{
  description = ''
    My super duper flake
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
      # Set of all hosts with their respective settings
      hosts = {
        "leet" = {
          system = "x86_64-linux"; # System architecture, one of the supported systems defined in a `supportedSystems` set below
          stateVersion = "24.11"; # Should match the iso's version for compatibility or whatever

          # List of modules whose options get exposed in your host configuration file
          modules = with inputs; [
            # stylix.nixosModules.stylix
					];

          # Set of host's users
          users = {
            "verz" = {
              # List of modules whose options get exposed in your home configuration file
              modules = with inputs; [
                ags.homeManagerModules.default
                nvf.homeManagerModules.default
                stylix.homeManagerModules.stylix
                nixcord.homeManagerModules.default
                spicetify-nix.homeManagerModules.default
              ];
            };

            # Second user ...
          };
        };

        # Second host ...
      };
    };

    # Set of all supported systems
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

    forAllSystems = lib.genAttrs (lib.concatLists (lib.attrValues supportedSystems));
  in {
    # Creating multiple nixos configurations using the hosts set, to select one during install/rebuild: --flake flakepath#hostname
    nixosConfigurations = lib.mapAttrs (
      hostname: host:
        lib.nixosSystem {
          system = host.system;
          modules = [./hosts] ++ host.modules;

          # Stuff passed to modules as inputs/arguments
          specialArgs = {
            # pkgs passed by default
            pkgs-stable = nixpkgs-stable.legacyPackages.${host.system};
            pkgs-master = nixpkgs-master.legacyPackages.${host.system};

            inherit inputs host hostname;
          };
        }
    ) (lib.attrsets.filterAttrs (_: host: lib.elem host.system supportedSystems."linux") configuration.hosts);
    # ^ nixosConfigurations output set for linux hosts

    # I'm not sure whether this works
    # Creating multiple darwin (macos) configurations using the hosts set, to select one: --flake flakepath#hostname
    darwinConfigurations = lib.mapAttrs (
      hostname: host:
        nix-darwin.lib.darwinSystem {
          system = host.system;
          modules = [./hosts] ++ host.modules;

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
          lib.foldlAttrs (
            _acc2: username: user:
              _acc2
              // {
                "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
                  pkgs = nixpkgs.legacyPackages.${host.system};
                  modules = [./users] ++ user.modules;

                  # Stuff passed to modules as inputs/arguments
                  extraSpecialArgs = {
                    # pkgs passed by default
                    pkgs-stable = nixpkgs-stable.legacyPackages.${host.system};
                    pkgs-master = nixpkgs-master.legacyPackages.${host.system};

                    inherit inputs host hostname username;
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
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; # Unstable branch, used as default
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.11"; # Stable branch
    nixpkgs-master.url = "github:nixos/nixpkgs?ref=master"; # Master branch, won't ever use this (i think)

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
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    # Widgets flake)
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim flake
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wide themes flake
    stylix = {
      url = "github:danth/stylix";
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