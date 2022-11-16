{ pkgs, ... }:

let

  nix = pkgs.nix;
  buildWorkingDir = "${home.homeDirectory}/build";
  buildScript = "${home.homeDirectory}/build.sh";
  configRepo = "git@github.com:SeineEloquenz/nixos-config";

in {

  home.packages = [
    bash
    git
    ls
  ];

  home.file."build.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      pushd ./nixos-config
      git pull
      hosts=$(ls ./hosts)
      for host in $hosts
      do
        nix --extra-experimental-features nix-command --extra-experimental-features flakes build .\#nixosConfigurations.$host.config.system.build.toplevel
      done
      popd
    '';
    onChange = ''
      pushd ${buildWorkingDir}
      if [[ ! -d "nixos-config" ]]; then
        git clone ${configRepo} nixos-config
      fi
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
          WorkingDirectory = $buildWorkingDir;
          ExecStart = $buildScript;
        };
      };
    };

    timers = {
      build = {
        Unit = {
          Description = "Continuously build all systems";
        };
        Timer = {
          OnCalendar = "*-*-01 06:00:00";
          Unit = "build.service";
        };
        Install = {
          WantedBy = "basic.target";
        };
      };
    };
  };
}
