{inputs}: let
  inherit (inputs) nixos-hardware;
in {
  inherit (nixos-hardware.nixosModules) common-pc;
}
