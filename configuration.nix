# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];
 
  boot.loader.grub = {
    enable = true;
  	devices = [ "nodev" ];
  	useOSProber = false;
  };

  boot.kernelParams = [
  	"quiet"
	  "loglevel=3"
  ];
  
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  networking.hostName = "ebobo"; 
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Europe/Kyiv";
 
  services.openssh.enable = true;
  services.dbus.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.enable = true;
  services.libinput.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.printing.enable = true;
  services.pulseaudio.enable = true;
  services.pipewire = {
     enable = false;
     pulse.enable = true;
  };

  users.users.nicht = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "tss" ];
     packages = with pkgs; [
       tree
     ];
  };

  # home-manager.users.nicht = { pkgs, ... }: {
  #   home.stateVersion = "22.11";  
  #   home.packages = [ ];  
  # };

  environment.systemPackages = with pkgs; [
    kitty
  	alacritty
    vim
    fish
  	tmux 
    wget
  	helix
  	yazi
  	gitui
  	git
  	tpm2-tools
  	tpm2-tss
  	cryptsetup
  	tpm2-tools
  	tpm2-tss
  	dunst
  	wl-clipboard
  	grim
  	signal-desktop
  	fastfetch 
	];

  programs.firefox.enable = true; 
  programs.hyprland.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  fonts.fontconfig.useEmbeddedBitmaps = true;
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.ubuntu
  ];    
  
  system.copySystemConfiguration = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}

