Dockerfile Starter Template
===========================

This directory mainly contains the Dockerfile for building my experiment
environment based on Ubuntu CUDA image.

Some features:
- It installs some necessary packages.
- Login as user `dev` with `sudo` privilege.  Shared volume are readable and
  writable from both the container and the host sides.
- Some useful system configuration files, e.g., `.bashrc`, `.tmux.conf`, etc.
- A convenient command-line function to start the container.
