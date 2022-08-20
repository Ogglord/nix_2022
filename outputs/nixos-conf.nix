{ lib, inputs, system, hardware, ... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs hardware; };
    modules = [
      ../system/machine/thinkpad
      ../system/configuration.nix
    ];
  };

  # tongfang-amd = lib.nixosSystem {
  #   inherit system;
  #   specialArgs = { inherit inputs hardware; };
  #   modules = [
  #     ../system/machine/tongfang-amd
  #     ../system/configuration.nix
  #   ];
  # };
}
