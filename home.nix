{ pkgs, nix-serve, ... }: {

  imports = [
    ./gc.nix
    ./nix-serve.nix
    ./build.nix
    ./update.nix
  ];

  home = {
    username = "alexa";
    homeDirectory = "/home/alexa";
    stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
  };

  programs.home-manager.enable = true;
}
