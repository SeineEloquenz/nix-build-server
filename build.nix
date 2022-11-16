{ config, pkgs, ... }:

let

  nix = pkgs.nix;
  buildWorkingDir = "${config.home.homeDirectory}/build";
  buildScript = "${config.home.homeDirectory}/build.sh";

in {

  home.packages = with pkgs; [
    bash
    git
  ];

  home.file."build.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      pushd ${buildWorkingDir}/nixos-config
      git pull
      hosts=$(ls ./hosts)
      for host in $hosts
      do
        ${pkgs.nix}/bin/nix build .\#nixosConfigurations.$host.config.system.build.toplevel
      done
      popd
    '';
  };

  systemd.user = {
    services = {
      build = {
        Unit = {
          Description = "Build all nix systems";
        };
        Service = {
          Type = "oneshot";
          WorkingDirectory = "${buildWorkingDir}";
          ExecStart = "${buildScript}";
        };
      };
    };

    timers = {
      build = {
        Unit = {
          Description = "Continuously build all systems";
        };
        Timer = {
          OnCalendar = "*:0/15";
          Unit = "build.service";
        };
        Install = {
          WantedBy = [ "basic.target" ];
        };
      };
    };
  };
}
