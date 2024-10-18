{
  description = "This Nix flake creates a development shell for a Python2 project that requires the ndb Python package which is the library for interacting with Google Datastore database.";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-py27.url = "github:nixos/nixpkgs/272744825d28f9cea96fe77fe685c8ba2af8eb12";
  };

  outputs = { flake-utils, nixpkgs, nixpkgs-py27, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        py27 = nixpkgs-py27.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            (py27.python2.withPackages (ps: [
              ps.pip
              ps.virtualenv
            ]))
            pkgs.bashInteractive
          ];
          # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
        };
      });
}
