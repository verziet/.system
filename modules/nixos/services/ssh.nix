{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."ssh".enableModule = lib.mkOption {
    description = "Enable the ssh module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."ssh".enableModule {
    services.openssh = {
      enable = lib.mkForce true;
      ports = lib.mkDefault [22];

      settings = {
        PasswordAuthentication = lib.mkDefault true;
        AllowUsers = lib.mkDefault null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = lib.mkDefault true;
        X11Forwarding = lib.mkDefault false;
        PermitRootLogin = lib.mkDefault "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
  };
}
