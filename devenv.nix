# SPDX-FileCopyrightText: 2024 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
{
  languages = {
    nix.enable = true;
    shell.enable = true;
  };
  devcontainer.enable = true;
  difftastic.enable = true;
  git-hooks = {
    excludes = [
      ".direnv/"
      ".devenv/"
      ".devenv.flake.nix"
      ".devenv.d*/"
    ];

    hooks = {
      actionlint.enable = true;
      alejandra = {
        enable = true;
      };
      deadnix = {
        enable = true;
      };
      markdownlint = {
        enable = true;
      };
      reuse = {
        enable = false;
      };
      statix = {
        enable = true;
        settings.ignore = [
          ".direnv/"
          ".devenv/"
          ".devenv.flake.nix"
          ".devenv*/"
        ];
      };
    };
  };
}
