{
  description = ''''; #TODO

  # Flake outputs
  outputs = {
    self,

    nixpkgs,
    nixpkgs-stable,
    nixpkgs-master,

    nix-darwin,
    home-manager,
    ...
  } @ inputs:
    let
    #FIXME Change the configuration
    configuration = {
      # List of all hosts with their respective settings
      # 
      hosts = {
        "leet" = {
          system = "x86_64-linux"; # System architecture, one of the supported systems defined below
          stateVersion = "24.11"; # Should match the iso's version for compatibility

          # List of host's users
          users = [
            "verz"
          ];
        };
        
        # Add more hosts if desired
      };
    };

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
    # Creating multiple nixos configurations using the hosts set, to select one during install/rebuild: --flake path#host
    nixosConfigurations = lib.mapAttrs (hostname: host:
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
    # ^ nixosConfigurations output for linux hosts

    # I'm not sure whether this works
    # Creating multiple darwin (mac) configurations using the hosts set, to select one: --flake path#host
    darwinConfigurations = lib.mapAttrs (hostname: host:
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
    # ^ darwinConfigurations output for mac hosts

    # Creating multiple home configurations using the multiple users lists while looping through hosts
    homeConfigurations = lib.attrsets.foldlAttrs
      (_acc: hostname: host:
        lib.foldl (_acc2: username: _acc2 // {
          "${username}" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${host.system};
            modules = [./users];

            # Stuff passed to modules as inputs/arguments
            extraSpecialArgs = {
              # pkgs passed by default
              pkgs-stable = nixpkgs-stable.legacyPackages.${host.system};
              pkgs-master = nixpkgs-master.legacyPackages.${host.system};
              inherit inputs host hostname username configuration;
            };
          };
        }) _acc host.users
      ) {}
      configuration.hosts;

    */ # TODO was just experimenting
    packages = forAllSystems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = self.packages.${system}.rebuild;

        rebuild = pkgs.writeShellApplication {
          name = "rebuild";
          runtimeInputs = with pkgs; [ git nh ]; # I could make this fancier by adding other deps
          text = ''${./scripts/rebuild.sh} . ''
	  + toString (lib.length (lib.attrNames configuration.hosts)) # Pass hosts length, in order to parse later
	  + " " + lib.concatStringsSep " " (lib.attrNames configuration.hosts) # And the hosts themselves
	  + " \"$@\"";
        };

        
        install = pkgs.writeShellApplication {
          name = "install";
          runtimeInputs = with pkgs; [ git nh ]; # I could make this fancier by adding other deps
          text = ''source ${./scripts/install.sh}'';
        };
      });

    apps = forAllSystems (system: {
      default = self.apps.${system}.rebuild;

      rebuild = {
        type = "app";
        program = "${self.packages.${system}.rebuild}/bin/rebuild";
      };

      install = {
        type = "app";
        program = "${self.packages.${system}.install}/bin/install";
      };
    });
    */
    
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra); # Most popular formatter, use with nix fmt
  };

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; # Unstable branch, used as default (ily Arch <3)
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.11"; # stable branch
    nixpkgs-master.url = "github:nixos/nixpkgs?ref=master"; # Master branch (extreme rolling release), won't ever use this (i think)

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "https://github.com/nix-community/home-manager/archive/master.tar.gz"; # Unstable home-manager, cuz we ain't no grans yo
      # url = "https://flakehub.com/f/nix-community/home-manager/*.tar.gz";
      # ^ latest stable home-manager, use in case of any problems (very unlikely, here as a fallback) #TODO might also cause problems

      inputs.nixpkgs.follows = "nixpkgs"; # Would dupe nixpkgs otherwise
    };
  };
}
