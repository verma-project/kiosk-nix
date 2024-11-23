# SPDX-FileCopyrightText: 2024 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
{
  description = "A very basic flake";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
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
    nix-github-actions.url = "github:shymega/nix-github-actions?ref=shymega-patch";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  nixConfig = {
    substituters = [
      "https://kiosk-nix.cachix.org?priority=10"
      "https://cache.nixos.org?priority=15"
    ];
    trusted-public-keys = [
      "kiosk-nix.cachix.org-1:3PObJTqAZqXFU7Mdo3MfBNbGUWsAUgHksH8rXbPXAcY="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  outputs = {self, ...} @ inputs: let
    inherit (inputs.flake-utils.lib) eachDefaultSystem;
    treeFmtEachSystem = f: inputs.nixpkgs.lib.genAttrs (import inputs.systems) (system: f genPkgs system);
    treeFmtEval = treeFmtEachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./nix/formatter.nix);

    genPkgs = system:
      import inputs.nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
      };
  in
    eachDefaultSystem (
      system: let
        pkgs = genPkgs system;
      in {
        packages =
          {
            devenv-up = self.devShells.${system}.default.config.procfileScript;
            devenv-test = self.devShells.${system}.default.config.test;
          }
          // import ./packages {inherit pkgs system inputs;};

        devShells.default = inputs.devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [./devenv.nix];
        };
      }
    )
    // {
      githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
        # Enable support for arm64 Linux + armv7l/armv6l.
        checks =
          inputs.nixpkgs.lib.getAttrs [
            "x86_64-linux"
            "aarch64-linux"
          ]
          self.checks;
      };
      checks = treeFmtEachSystem (pkgs: {
        formatting = treeFmtEval.${pkgs.system}.config.build.wrapper;
        inherit (self.devShells.${pkgs.system}.default) ci;
      });

      formatter = treeFmtEachSystem (pkgs: treeFmtEval.${pkgs.system}.config.build.wrapper);
    };
}
