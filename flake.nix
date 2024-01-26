{
  description = "Declarative home configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          homeConfigurations =
            {
              prsteele = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [ ./home.nix ];
              };
            };

          # Convenience wrapper around rebuilding with flakes
          switch = pkgs.writeShellApplication {
            name = "switch";
            runtimeInputs = [home-manager.packages.${system}.default];
            text = ''
            home-manager switch --flake .
            '';
          };

          default = self.packages.${system}.switch;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
