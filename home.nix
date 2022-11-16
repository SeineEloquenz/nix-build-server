{ pkgs, ... }: {

  imports = [
    ./gc.nix
    ./nix-serve.nix
    ./build.nix
  ];

  home = {
    username = "your.username";
    homeDirectory = "/home/your.username";
    stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
  };

  programs.home-manager.enable = true;
}
