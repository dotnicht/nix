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
    kernelPackages = pkgs.linuxPackages_zen;
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
      configurationLimit = 30;
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
    greetd = {
      enable = true;
      # settings = rec {
      #   initial_session = {
      #     command = "start-hyprland -- -c /etc/greetd/hypr.conf";
      #     user = "greeter";
      #   };
      #   default_session = initial_session;
      # };
    };
    desktopManager.cosmic.enable = true;
    displayManager = {
      cosmic-greeter.enable = true;
      autoLogin = {
        enable = true;
        user = "nicht";
      };
    };
    # system76-scheduler.enable = true;
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
    udev.packages = with pkgs; [
      nitrokey-udev-rules
      yubikey-personalization
    ];
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

  environment = {
    systemPackages = with pkgs; [
      alacritty
      anyrun
      bottom
      brightnessctl
      cryptsetup
      dunst
      fastfetch
      flashrom
      git
      gitui
      grim
      helix
      hyprcursor
      opensc
      rclone
      pynitrokey
      rustup
      starship
      tmux
      tpm2-tools
      tpm2-tss
      wget
      wireguard-tools
      wl-clipboard
      yazi
      zellij
    ];
    variables = {
      EDITOR = "hx";
      # HYPRCURSOR_THEME = "Adwaita";
      # HYPRCURSOR_SIZE = 48;
    };
  };

  programs = {
    regreet.enable = true;
    fish.enable = true;
    firefox.enable = true;
    mtr.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
    };
    packages = with pkgs.nerd-fonts; [
      fira-code
      droid-sans-mono
      noto
      hack
      ubuntu
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  system.copySystemConfiguration = true;
  system.stateVersion = "25.11";
}
