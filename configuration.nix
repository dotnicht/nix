# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    # ./home-manager.nix
  ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "quiet"
      "loglevel=3"
    ];
    loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      useOSProber = false;
      efiSupport = false;
      copyKernels = true;
    };
  };

  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };

  networking = {
    hostName = "ebobo";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = false;
    };
  };

  time.timeZone = "Europe/Kyiv";

  services = {
    udev.packages = [
      pkgs.nitrokey-udev-rules
      pkgs.yubikey-personalization
    ];
    greetd.enable = true;
    openssh.enable = true;
    dbus.enable = true;
    libinput.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = false;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        options = "eurosign:e,caps:escape";
      };
    };
  };

  users.users.nicht = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "tss"
    ];
    packages = with pkgs; [
      tree
      signal-desktop
      spotify
      protonvpn-gui
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    tmux
    wget
    helix
    yazi
    gitui
    git
    tpm2-tools
    tpm2-tss
    cryptsetup
    dunst
    wl-clipboard
    grim
    fastfetch
    bottom
    anyrun
    zellij
    uwsm
    wireguard-tools
    starship
    rustup
    brightnessctl
    flashrom
    hyprcursor
  ];

  programs = {
    regreet.enable = true;
    fish.enable = true;
    firefox.enable = true;
    hyprland.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
    };
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.noto
      nerd-fonts.hack
      nerd-fonts.ubuntu
    ];
  };

  system.copySystemConfiguration = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "hx";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

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
