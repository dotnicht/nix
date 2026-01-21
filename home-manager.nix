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
      programs.home-manager.enable = true;
      home.stateVersion = "22.11";
    };
}
