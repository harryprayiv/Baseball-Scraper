{
  description = "Baseball Scraper";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }: (utils.lib.eachSystem ["x86_64-linux"] (system: rec {
    packages = {
      pythonEnv =
        nixpkgs.legacyPackages.${system}.python3.withPackages
        (ps: with ps; [requests beautifulsoup4 websocket-client selenium]);
    };
    pkgs.python3Packages.buildPythonPackage = {
      name = "baseball_scrapes";
      src = ./.;
      propagatedBuildInputs = [(nixpkgs.legacyPackages.${system}.python3.withPackages (ps: with ps; [requests websocket-client beautifulsoup4 selenium]))];
    };
    defaultPackage = packages.pythonEnv; # If you want to just build the environment
    devShell = packages.pythonEnv.env; # We need .env in order to use `nix develop`
  }));
}