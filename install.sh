#!/usr/bin/env bash

set -eu

if [ "$EUID" -eq 0 ]; || grep -q "ID=arch" /etc/os-release; then
  echo "start installing Arch Linux"
else
  echo "nothing to do"
  exit 1
fi
