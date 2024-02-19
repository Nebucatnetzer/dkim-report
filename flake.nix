{
  description = "A simple flake to generate DKIM reports.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        reports = pkgs.writeShellApplication {
          name = "reports";
          runtimeInputs = [
            pkgs.dmarc-report-converter
            pkgs.gnutar
            pkgs.python3
            pkgs.unzip
          ];
          text = (builtins.readFile ./reports.sh);
        };
      in
      {
        packages.dkim-report = reports;
        packages.default = reports;
        apps.dkim-report = {
          type = "app";
          program = "${self.packages.${system}.dkim-report}/bin/reports";
        };
        apps.default = self.apps.${system}.dkim-report;
      }
    );
}
