{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.nicht =
    { pkgs, ... }:
    {
      programs = {
        home-manager.enable = true;
        bat.enable = true;
        wezterm.enable = true;
        firefox.enable = true;
        git.enable = true;
        neovim.enable = true;
        nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
          flake = "/home/nicht/"; # sets NH_OS_FLAKE variable for you
        };
      };

      home.stateVersion = "25.11";
    };
}
