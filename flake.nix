{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
  };
  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
  flake-utils.lib.eachDefaultSystem
  (system:
    let
      overlays = [ gomod2nix.overlays.default ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
    in
    with pkgs;
    {
      inherit system;
      devShells.default = mkShell {
        buildInputs = [
          go
          gopls
          gotools
          go-tools
          gomod2nix.packages.${system}.default
          sqlite-interactive
        ];
        shellHook = ''
          export GOPATH=`pwd`
          export PATH=$GOPATH/bin:$PATH
        '';

      };
    }
  );
}
