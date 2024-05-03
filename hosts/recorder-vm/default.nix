{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./../../modules/nixos/common.nix
    ./../../modules/nixos/imincik-user.nix
    ./../../modules/nixos/recorder.nix
    ./../../modules/nixos/vm.nix
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

  # VM port forwarding
  virtualisation.forwardPorts = [
    {
      from = "host";
      host.port = 8080;
      guest.port = 80;
    }

    {
      from = "host";
      host.port = 8443;
      guest.port = 443;
    }

    {
      from = "host";
      host.port = 8083;
      guest.port = 8083;
    }
  ];

  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = "x86_64-linux";
}
