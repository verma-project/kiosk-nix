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
  git-hooks.hooks = {
    actionlint.enable = true;
    deadnix.enable = true;
    markdownlint.enable = true;
    nixfmt-rfc-style.enable = true;
    reuse.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
    statix = {
      enable = true;
      settings.ignore = [
        ".direnv"
        ".devenv*"
      ];
    };
  };
}
