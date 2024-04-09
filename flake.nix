{
  description = "A simple flake to generate DKIM reports.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = rec {
          dkim-report = pkgs.writeShellApplication {
            name = "reports";
            runtimeInputs = [
              pkgs.dmarc-report-converter
              pkgs.python3
            ];
            text = (builtins.readFile ./reports.sh);
          };
          default = dkim-report;
        };
        apps = rec {
          dkim-report = flake-utils.lib.mkApp { drv = self.packages.${system}.dkim-report; };
          default = dkim-report;
        };
      }
    );
}
