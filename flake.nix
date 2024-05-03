{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    hillingar.url = "github:RyanGibb/hillingar";

    hillingar.inputs.opam-repository.follows = "opam-repository";
    hillingar.inputs.opam-overlays.follows = "opam-overlays";
    opam-repository = {
      url = "github:ocaml/opam-repository";
      flake = false;
    };
    opam-overlays = {
      url = "github:dune-universe/opam-overlays";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, hillingar, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        packages =
          let
            mirage-nix = (hillingar.lib.${system});
            inherit (mirage-nix) mkUnikernelPackages;
          in
          mkUnikernelPackages
            {
              unikernelName = "tiny-chef";
              # list external dependencies here
              depexts = with pkgs; [ gmp ];
              monorepoQuery = {
                zarith = "1.13+dune+mirage";
              };
              query = {
                ocaml-base-compiler = "*";
                mirage = "4.5.0";
              };
            } ./.;
        defaultPackage = self.packages.${system}.unix;
        formatter = pkgs.nixpkgs-fmt;
        dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "nickrobison/tiny-chef";
          tag = "latest";
          contents = [
            (pkgs.buildEnv {
              name = "app";
              paths = [ self.packages.${system}.unix ];
            })
          ];
          config.Cmd = [ "/tiny-chef" ];
          config.ExposedPorts = {
            "8080/tcp" = { };
          };
        };
      }
    );
}
