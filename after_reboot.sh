#!/bin/bash

# Print every line being executed
set -x

# Unmute with amixer
sudo amixer sset Master unmute
sudo amixer sset Speaker unmute
sudo amixer sset Headphone unmute
sudo alsactl store

sudo timedatectl set-timezone America/New_York
