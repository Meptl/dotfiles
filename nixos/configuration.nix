# vim: set softtabstop=3 tabstop=2 shiftwidth=2 expandtab autoindent syntax=nix nocompatible :

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # Hardware scan
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    plymouth.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = [ "i915.nuclear_pageflip=1" ];
  };

  networking = {
    hostName = "bounce";
    networkmanager.enable = true;
    #networkmanager.dhcp = "dhcpcd";
  };

  nixpkgs.overlays = [
    (import ./overlays/rust-overlay.nix)
  ];

  environment.systemPackages = with pkgs; [
    (import ./discord.nix)
    firefox
    (import ./vim.nix) git python3 gcc rustChannels.nightly.rust cmake gnumake
    p7zip file patchelf wget microcodeIntel
    redshift xorg.xbacklight xorg.xrandr rxvt_unicode i3status
  ];

  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager.lightdm.enable = true;
    libinput.enable = true;
    xkbOptions = "ctrl:nocaps";
    videoDrivers = [ "modesetting" "intel" "ati"];
    useGlamor = true;
  };

  users.extraUsers.yutoo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };

  hardware.opengl = {
    driSupport = true;
    extraPackages = with pkgs; [
        vaapiIntel     # Video Accel API by Intel
        libvdpau-va-gl # VDPAU abstraction to VAAPI
        beignet        # OpenCL for Intel
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # The NixOS release to be compatible with for stateful data such as databases.
  time.timeZone = "America/New_York";
  system.stateVersion = "17.03";
}
