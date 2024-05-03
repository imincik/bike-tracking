# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  owntracks-recorder = pkgs.callPackage ./owntracks-recorder { };
  owntracks-frontend = pkgs.callPackage ./owntracks-frontend { };
}
