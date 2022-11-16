# nix-build-server
This is the nix configuration for my personal binary cache and nix build server.

If you want to use this for your own purposes you should fork the repository and change all occurences of my data to yours.
If I find time I might consider to actually make this a proper configurable module instead of a monolithic configuration.

To set this up follow these steps:

1. Run `setup.sh`
2. Ensure that `~/cache.sk` exists
3. Ensure that a valid ssh key with access rights to the git repo exists
4. Run `switch.sh`
