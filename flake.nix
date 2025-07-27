{
  description = "NixOS Server Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ragenix.url = "github:yaxitech/ragenix";
  };

  outputs =
    {
      self,
      nixpkgs,
      ragenix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        n-server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hardware
            ./servers
            ./system
            ./secrets/default.nix
            {
              nixpkgs = {
                config = {
                  allowUnfree = true;
                };
                overlays = [ ];
              };
            }
            ragenix.nixosModules.default
            {
              environment.systemPackages = [ ragenix.packages.${system}.default ];
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
