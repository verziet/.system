{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."spicetify-nix".enableModule = lib.mkOption {
    description = "Enable the spicetify-nix module";
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config."spicetify-nix".enableModule {
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${host.system};
    in {
      enable = lib.mkForce true;
      enabledCustomApps = lib.mkDefault [
        {
          # The source of the customApp
          # make sure you're using the correct branch
          # It could also be a sub-directory of the repo
          src = pkgs.fetchFromGitHub {
            owner = "spicetify";
            repo = "cli";
            rev = "main";
            hash = "sha256-2fsHFl5t/Xo7W5IHGc5FWY92JvXjkln6keEn4BZerw4=";
          };
          # The actual file name of the customApp usually ends with .js
          name = "lyrics-plus";
        }
      ];

      enabledExtensions = lib.mkDefault (with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
      ]);

      theme = lib.mkDefault spicePkgs.themes.text;
    };
  };
}
