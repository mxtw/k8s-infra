#!/usr/bin/env bash


SCRIPT_DIR=$(dirname "$(realpath "$0")")


cd "$SCRIPT_DIR"/../tf || exit

HOST=$(tofu output -raw server-ip)

cd "$SCRIPT_DIR" || exit

scp root@"${HOST}":/etc/rancher/k3s/k3s.yaml ./kubeconfig

sed -i "s/127.0.0.1/${HOST}/" ./kubeconfig
