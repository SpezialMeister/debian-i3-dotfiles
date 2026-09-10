# Vendored: better-autotile-c

Source: https://github.com/metzna/better-autotile-c
Vendored version: 0.2.0 (container flattening)

This is a plain copy of the source (not a git submodule) so a fresh machine
can build the binary without needing access to the separate repo. It is
built and installed to `/usr/local/bin/better_autotile` by
`scripts/build-better-autotile.sh` during setup.

To update: copy `main.c`, `Makefile`, and `vendor/cJSON.{c,h}` from the
upstream repo over these files and bump the version noted above.
