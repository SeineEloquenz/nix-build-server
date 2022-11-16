#!/bin/bash
pushd ./nixos-config
git pull
hosts=$(ls ./hosts)
for host in $hosts
do
        nix --extra-experimental-features nix-command --extra-experimental-features flakes build .\#nixosConfigurations.$host.config.system.build.toplevel
done
popd
