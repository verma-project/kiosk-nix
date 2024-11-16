# SPDX-FileCopyrightText: 2024 Dom Rodriguez
#
# SPDX-License-Identifier: MIT

{
  description = "A very basic flake";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default-linux";
    nix-github-actions.url = "github:nix-community/nix-github-actions";
  };

  nixConfig = {
    extra-trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    extra-trusted-substituters = [ "https://cache.nixos.org/" ];
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib) eachDefaultSystem;
      genPkgs = system: inputs.nixpkgs.legacyPackages.${system};
    in
    eachDefaultSystem (
      system:
      let
        pkgs = genPkgs system;
      in
      {
        packages = {
          inherit (pkgs) hello;
          devenv-up = self.devShells.${system}.default.config.procfileScript;
          devenv-test = self.devShells.${system}.default.config.test;
        };

        devShells.default = inputs.devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [ ./devenv.nix ];
        };

        checks = {
          inherit (pkgs) hello;
        };
      }
    )
    // {
      githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
        # Enable support for arm64 Linux + armv7l/armv6l.
        checks = inputs.nixpkgs.lib.getAttrs [ "x86_64-linux" ] self.checks;
      };
    };
}
