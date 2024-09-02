{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = ((import nixpkgs) {
          inherit system;
        });
        lib = pkgs.lib;
        stdenv = pkgs.stdenv;
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gnumake
            (python311.withPackages (ps: with ps; [ toml ]))
          ] ++ lib.optional stdenv.isDarwin [
          ];
        };
      }
    );
}
