{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./../../modules/nixos/common.nix
    ./../../modules/nixos/imincik-user.nix
    ./../../modules/nixos/tracker.nix
    ./../../modules/nixos/ec2.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
      };
      channel.enable = false;

      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  networking.hostName = "recorder";

  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = "x86_64-linux";
}
