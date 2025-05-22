{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };
  outputs = { self, nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      nixpkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor."${system}";
        in rec {
          default = ctlssa;
          ctlssa = pkgs.callPackage ./nix/pkgs/ctlssa.nix { inherit self pkgs; };
          certstream-server-go = pkgs.callPackage ./nix/pkgs/certstream-server-go.nix { inherit pkgs; };
        });

      apps = forAllSystems (system: {
        certstream-server = {
          type = "app";
          program = "${self.packages."${system}".certstream-server-go}/bin/certstream";
        };
      });

      # export a module to be used in NixOS configurations
      nixosModules.ctlssa = nixpkgs.lib.modules.importApply ./nix/module.nix { inherit self; };

      # create a shell configuration for running/developing CTLSSA using `nix develop` or Direnv
      devShells = forAllSystems (system: {
        default = nixpkgsFor."${system}".pkgs.mkShell {
          DJANGO_SETTINGS_MODULE = "ctlssa.app.settings";
          UWSGI_MODULE = "ctlssa.app.wsgi";
          UWSGI_HTTP_SOCKET = ":8001";
          UWSGI_MASTER = "1";
          UWSGI_UID = "nobody";
          DJANGO_PORT = "8001";

          buildInputs = [
            self.packages."${system}".ctlssa
          ];
        };
      });

    };
}
# let pkgs = nixpkgs.legacyPackages.${system};
#     in rec {
#       packages = flake-utils.lib.flattenTree rec {
#         default = ctlssa;
#       };
#       # create a shell configuration for running/developing CTLSSA using `nix develop` or Direnv
#       devShells.default = pkgs.mkShell {
#         DJANGO_SETTINGS_MODULE = "ctlssa.app.settings";
#         UWSGI_MODULE = "ctlssa.app.wsgi";
#         UWSGI_HTTP_SOCKET = ":8001";
#         UWSGI_MASTER = "1";
#         UWSGI_UID = "nobody";
#         DJANGO_PORT = "8001";

#         buildInputs = [ packages.ctlssa ];
#       };
#     }) //
# {
#   # add module for installing CTLSSA in NixOS
#   # nixosModules.ctlssa = nixpkgs.lib.modules.importApply ./module.nix { inherit self pkgs lib; };
#   # nixosModules.default = ({ pkgs, ... }: {
#   #   imports = [ ./module.nix ];
#   #   nixpkgs.overlays = [ (_self: _super: { ctlssa = self.packages.${pkgs.system}.ctlssa; }) ];
#   # });
# };
# }
