#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt update && apt upgrade -y
apt install -y traceroute

reboot
