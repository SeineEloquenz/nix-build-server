{ pkgs, ... }:
{
  systemd.user = {
    services = {
      gc = {
        Unit = {
          Description = "Run nix garbage collection";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "nix-store --gc";
        };
      };
    };

    timers = {
      gc = {
        Unit = {
          Description = "Continuously run nix garbage collection";
        };
        Timer = {
          OnCalendar = "*-*-01 05:00:00";
          Unit = "gc.service";
        };
        Install = {
          WantedBy = "basic.target";
        };
      };
    };
  };
}
