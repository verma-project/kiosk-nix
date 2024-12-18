# SPDX-FileCopyrightText: 2024 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
{
  pkgs,
  self,
  ...
}:
with pkgs; {
  libcec-daemon = callPackage ./libcec-daemon {};
  build-script = callPackage ./scripts/build-script {inherit self;};
}
