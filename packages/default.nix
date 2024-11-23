# SPDX-FileCopyrightText: 2024 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only

{pkgs, ...}:
with pkgs; {
  libcec-daemon = callPackage ./libcec-daemon {};
}
