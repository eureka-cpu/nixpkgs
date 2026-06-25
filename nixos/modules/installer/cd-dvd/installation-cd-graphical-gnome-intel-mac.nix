# This module defines a NixOS installation CD that contains GNOME,
# with support for WiFi adapters present in some Intel Macs (Broadcom).

{ config, pkgs, lib, ... }:

{
  imports = [ ./installation-cd-graphical-gnome.nix ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "broadcom-sta" ];
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "broadcom-sta" ];

  # This is real hardware — no VM guest additions needed
  services.spice-vdagentd.enable = lib.mkForce false;
  services.qemuGuest.enable = lib.mkForce false;
  virtualisation.vmware.guest.enable = lib.mkForce false;
  virtualisation.hypervGuest.enable = lib.mkForce false;
  services.xe-guest-utilities.enable = lib.mkForce false;

  # Drop Firefox and mesa-demos; epiphany (GNOME Web) is kept as the lightweight browser
  environment.defaultPackages = with pkgs; [
    gparted
    vim
    nano
    brave
  ];

  # Strip GNOME apps that serve no purpose on an installer ISO
  environment.gnome.excludePackages = with pkgs; [
    baobab            # disk usage analyzer
    cheese            # webcam app
    decibels          # audio player
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-connections # remote desktop client
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-tour        # first-run welcome tour
    gnome-user-docs
    gnome-weather
    seahorse          # passwords and keys
    simple-scan       # scanner app
    totem             # video player
    yelp              # help browser
  ];

  boot.initrd.kernelModules = [ "wl" ];

  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
}
