{ config, pkgs, ... }:

let repoDir = "${config.home.homeDirectory}/nix-build-server";

in {

  home.file."update.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      pushd ${repoDir}
      git pull
      sh switch.sh
      popd
    '';
  };

  systemd.user = {
    services = {
      update = {
        Unit = {
          Description = "Updates the server configuration";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${config.home.homeDirectory}/update.sh";
        };
      };
    };

    timers = {
      update = {
        Unit = {
          Description = "Continuously update the server configuration";
        };
        Timer = {
          OnCalendar = "*-*-* 02:00:00";
          Unit = "update.service";
        };
        Install = {
          WantedBy = [ "basic.target" ];
        };
      };
    };
  };
}
