# This module defines a NixOS installation CD that contains GNOME,
# with support for WiFi adapters present in some Intel Macs (Broadcom).

{ config, pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-gnome.nix ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "broadcom-sta" ];
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "broadcom-sta" ];

  # Strip packages that serve no purpose on an installer ISO
  environment.gnome.excludePackages = with pkgs; [
    baobab          # disk usage analyzer
    cheese          # webcam app
    decibels        # audio player
    epiphany        # web browser (firefox is already included)
    gnome-calendar
    gnome-clocks
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour      # first-run welcome tour
    gnome-user-docs
    gnome-weather
    simple-scan     # scanner app
    totem           # video player
    yelp            # help browser
  ];

  boot.initrd.kernelModules = [ "wl" ];

  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
}
