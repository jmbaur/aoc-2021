{
  description = "AOC 2021";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:arqv/zig-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, zig }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "aoc";
        version = "0.1.0";
        buildInputs = [ zig.packages.${system}.master.latest ];
        pkgs = nixpkgs.legacyPackages.${system};
      in
      with pkgs;
      rec {
        packages = flake-utils.lib.flattenTree {
          aoc = stdenv.mkDerivation {
            inherit name version buildInputs;
            src = builtins.path { path = ./.; };
            preBuild = ''
              export HOME=$TMPDIR
            '';
            installPhase = ''
              zig build --prefix $out install
            '';
          };
        };
        defaultPackage = packages.aoc;
        devShell = mkShell {
          inherit buildInputs;
        };
      });
}
