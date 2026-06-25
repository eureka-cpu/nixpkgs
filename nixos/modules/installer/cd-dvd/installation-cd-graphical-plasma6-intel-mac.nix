# This module defines a NixOS installation CD that contains Plasma 6,
# with support for WiFi adapters present in some Intel Macs (Broadcom).

{ config, pkgs, lib, ... }:

{
  imports = [ ./installation-cd-graphical-calamares-plasma6.nix ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "broadcom-sta" ];
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "broadcom-sta" ];

  # This is real hardware — no VM guest additions needed
  services.spice-vdagentd.enable = lib.mkForce false;
  services.qemuGuest.enable = lib.mkForce false;
  virtualisation.vmware.guest.enable = lib.mkForce false;
  virtualisation.hypervGuest.enable = lib.mkForce false;
  services.xe-guest-utilities.enable = lib.mkForce false;

  environment.defaultPackages = with pkgs; [
    gparted
    vim
    nano
    brave
  ];

  # Strip KDE apps that serve no purpose on an installer ISO
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-workspace-wallpapers
    elisa        # music player
    gwenview     # image viewer
    spectacle    # screenshot tool
    khelpcenter  # help browser
    krdp         # remote desktop
  ];

  boot.initrd.kernelModules = [ "wl" ];

  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
}
