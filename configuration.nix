{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nix-security-tool-box.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_6_16;
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "spoon";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
    packages = with pkgs; [
      terminus_font
    ];
    useXkbConfig = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  services = {
    hardware.bolt.enable = true;
    displayManager.ly.enable = true;
    xserver = {
      enable = true;
      # videoDrivers = [ "nvidia" "modesetting" ];
      xkb = {
        layout = "us";
        options = "ctrl:swapcaps";
      };
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      nvidiaPersistenced = true;
      open = false;
      prime = {
        # sync.enable = true;
        # reverseSync.enable = true;
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:0:6:0";
      };
    };
  };

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME="nvidia";
    # __NV_PRIME_RENDER_OFFLOAD = "1";
    # __VK_LAYER_NV_optimus = "NVIDIA_only";
    # WLR_DRM_NO_ATOMIC = "1";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 64;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 128;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.broarr = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  programs.firefox.enable = true;
  programs.niri.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    fuzzel
    git
    helix
    inxi
    libdrm
    lshw
    mesa-demos
    nvtopPackages.nvidia
    pciutils
    psmisc
    vim
    vulkan-tools
    wget
    wlr-randr
    xwayland
    xorg.xrandr
    xplugd
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}

