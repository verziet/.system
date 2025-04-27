{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."kanata".enableModule = lib.mkOption {
    description = "Enable the kanata module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."kanata".enableModule {
    environment.systemPackages = with pkgs; [
      playerctl
      brightnessctl
      wireplumber
    ];

    services.kanata = {
      enable = lib.mkForce true;
      package = pkgs.kanata-with-cmd;

      keyboards.internalKeyboard = {
        devices = [];

        extraDefCfg = ''
          process-unmapped-keys yes
          block-unmapped-keys yes
          danger-enable-cmd yes
        '';
        config = ''
                        ;; NOTE: media keys don't work themselves on hyprland, requires additional setup
                      ;; TODO: fix capital czech letters

                             ;; link containing all keys
                      ;; https://github.com/jtroo/kanata/blob/main/parser/src/keys/mod.rs

                        ;; all keys we're mapping
                             (defsrc
                                 `    1    2    3    4    5    6    7    8    9    0    -    =
                                 ⭾    q    w    e    r    t    y    u    i    o    p    [    ]
                                 ⇪    a    s    d    f    g    h    j    k    l    ;    '    ↩
                                 ‹⇧   z    x    c    v    b    n    m    ,    .    /
                                                          ␣
                             )

                      ;; function for smoother typing with home-row mods
                             (deftemplate charmod (char mod)
                               (switch
                                 ((key-timing 3 less-than 250)) $char break
                                 () (tap-hold-release-timeout 200 500 $char $mod $mod) break
                               )
                             )

                             (deflocalkeys-linux
                               mic 248
                             )

                             (defalias
                               ;; home-row mods
                               a (t! charmod a lmet)
                               s (t! charmod s lalt)
                               d (t! charmod d lsft)
                               f (t! charmod f rctl)

                               j (t! charmod j rctl)
                               k (t! charmod k rsft)
                               l (t! charmod l ralt)
                               ; (t! charmod ; rmet)

                               ;; second layer toggle
                               ␣ (t! charmod spc (layer-toggle layer-1))

                 ;; second layer capital toggle
                 ‹⇧ (t! charmod lsft (layer-toggle layer-1-shift))

                               ;; mute audio/mic
                               🔇 (tap-hold 0 250 🔇 mic)
          ◀◀ (tap-hold 0 250 (cmd playerctl previous) (cmd playerctl position 5-))
          ▶⏸ (cmd playerctl play-pause)
          ▶▶ (tap-hold 0 250 (cmd playerctl next) (cmd playerctl position 5+))


                               ;; number aliases for macro
                               1 1
                               2 2
                               3 3
                               4 4
                               5 5
                               6 6
                               7 7
                               8 8
                               9 9
                               0 0

                 ;; NOTE: supposing menu key toggles us/cz layout
                               ;; czech symbols
                               ť (macro menu S-= t menu)
                               ě (macro menu @2 menu)
                               š (macro menu @3 menu)
                               č (macro menu @4 menu)
                               ř (macro menu @5 menu)
                               ž (macro menu @6 menu)
                               ý (macro menu @7 menu)
                               á (macro menu @8 menu)
                               í (macro menu @9 menu)
                               é (macro menu @0 menu)
                               ď (macro menu S-= d menu)
                               ú (macro menu [ menu)
                               ó (macro menu = o menu)
                 ů (macro menu ; menu)
                               ň (macro menu S-= n menu)

                               ;; czech symbols capital
                               Ť (macro menu caps S-= t caps menu)
                               Ě (macro menu caps @2 caps menu)
                               Š (macro menu caps @3 caps menu)
                               Č (macro menu caps @4 caps menu)
                               Ř (macro menu caps @5 caps menu)
                               Ž (macro menu caps @6 caps menu)
                               Ý (macro menu caps @7 caps menu)
                               Á (macro menu caps @8 caps menu)
                               Í (macro menu caps @9 caps menu)
                               É (macro menu caps @0 caps menu)
                               Ď (macro menu caps S-= d caps menu)
                               Ú (macro menu caps [ caps menu)
                               Ó (macro menu caps = o caps menu)
                 Ů (macro menu caps ; caps menu)
                               Ň (macro menu caps S-= n caps menu)
                             )

                             (deflayer (layer-0)
                                 `    1    2    3    4    5    6    7    8    9    0    -    =
                                 ⭾    q    w    e    r    t    y    u    i    o    p    [    ]
                                 ⎋   @a   @s   @d   @f    g    h   @j   @k   @l   @;    '    ↩
                                 ‹⇧   z    x    c    v    b    n    m    ,    .    /
                                                         @␣
                             )

                             (deflayer (layer-1)
                                 `   @ť   @ě   @š   @č   @ř   @ž   @ý   @á   @í   @é   @ď     =
                                ⭾   🔇    ◀◀   ▶⏸  ▶▶   🔊    y    ↖    ↘   🔅   🔆   @ú    @ó
                                ⎋    @a   @s   @d   @f   🔉    ◀    ▼    ▲    ▶   @ů   @ň    ↩
                               @‹⇧    z    x    c    v    b    ⌫    ⌦    ,    .    /
                                                         @␣
                             )

                             (deflayer (layer-1-shift)
                                 `   @Ť   @Ě   @Š   @Č   @Ř   @Ž   @Ý   @Á   @Í   @É   @Ď     =
                                ⭾    @🔇  ◀◀   ▶⏸  ▶▶   🔊    y    ↖    ↘   🔅   🔆   @Ú    @Ó
                                ⎋    @a   @s   @d   @f   🔉    ◀    ▼    ▲    ▶   @Ů   @Ň    ↩
                               @‹⇧    z    x    c    v    b    ⌫    ⌦    ,    .    /
                                                         @␣
                             )
        '';
      };
    };
  };
}
