#!/usr/bin/env bash

# Print every line being executed
set -x

# Unmute with amixer
amixer sset Master unmute
amixer sset Speaker unmute
amixer sset Headphone unmute
alsactl store

timedatectl set-timezone America/New_York
