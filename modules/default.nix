{ inputs }: let
  inherit (inputs) nixos-hardware;
in {
  common-pc = nixos-hardware.nixosModules.common-pc;
}
