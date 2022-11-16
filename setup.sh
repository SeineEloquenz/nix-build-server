#!/bin/sh
mkdir -p ~/build
pushd ~/build
git clone git@github.com:/SeineEloquenz/nixos-config nixos-config
popd
mkdir -p ~/.config/nix
cp nix.conf ~/.config/nix/nix.conf
