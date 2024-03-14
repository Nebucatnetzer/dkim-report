{
  description = "A simple flake to generate DKIM reports.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          dkim-report = pkgs.writeShellApplication {
            name = "reports";
            runtimeInputs = [
              pkgs.dmarc-report-converter
              pkgs.python3
            ];
            text = (builtins.readFile ./reports.sh);
          };
          default = self.packages.${system}.dkim-report;
        }
      );
      apps = forEachSystem (system: {
        dkim-report = {
          type = "app";
          program = "${self.packages.${system}.dkim-report}/bin/reports";
        };
        default = self.apps.${system}.dkim-report;
      });
    };
}
