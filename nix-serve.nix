{ config, pkgs, ... }:

let nix-serve = pkgs.haskellPackages.nix-serve-ng;

in {

  home.packages = [
    nix-serve
  ];

  systemd.user = {
    services = {
      nix-serve = {
        Unit = {
          Description = "nix serve service";
        };

        Service = {
          Type = "simple";
          WorkingDirectory = "${config.home.homeDirectory}";
          IPAccounting = "true";

          ProtectSystem = "full";

          Restart = "always";
          RestartSec = "5";
          Environment = "NIX_SECRET_KEY_FILE=~/cache.sk";
          ExecStart = "${nix-serve}/bin/nix-serve";
          KillMode = "process";
        };

        Install = {
          WantedBy = [ "multi-user.target" ];
        };
      };
    };
  };
}
