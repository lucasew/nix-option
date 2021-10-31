{pkgs ? import <nixpkgs> {}, ...}@args:
pkgs.callPackage ./package.nix args
