#!/usr/bin/env bash

source .env

export KUBECONFIG=./kubeconfig

flux bootstrap github \
  --owner=mxtw \
  --repository=k8s-infra \
  --branch=main \
  --path=./flux \
  --personal
