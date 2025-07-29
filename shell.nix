{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
let
  inherit (pkgs) lib;
  treefmt-nixSrc = builtins.fetchTarball "https://github.com/numtide/treefmt-nix/archive/refs/heads/master.tar.gz";
  treefmt-nix = import treefmt-nixSrc;
in
(pkgs.buildFHSEnv {
  name = "simple-env";
  # Installed for host pc only
  targetPkgs =
    pkgs:
    (with pkgs; [
      # For getting python deps
      uv
      # Need to use a nix python to prevent ssl certs issues
      python312
      # needed by lxml
      libxslt
      libxml2
      # For less compilation
      lessc
      # Needed for git clean in full rebuilds
      git
      # Needed for compiling minifiers
      libffi
      go
      # Formatter
      (treefmt-nix.mkWrapper pkgs {
        # Used to find the project root
        projectRootFile = "shell.nix";
        enableDefaultExcludes = true;
        programs = {
          ruff-check.enable = true;
          ruff-format.enable = true;
          nixfmt.enable = true;
        };
        settings = {
          global = {
            on-unmatched = "debug";
            excludes = [
              ".nltk_data"
              ".venv"
            ];
          };
        };
      })
      # Packages for git hooks
      mediainfo
      perl
      file
    ]);
  # Installed for every architecture: only install the lib outputs
  multiPkgs =
    pkgs:
    (with pkgs; [
    ]);
  runScript = pkgs.writeShellScript "fsfe-website-env" ''
    set -euo pipefail
    # Force uv to use Python interpreter from venv
    export UV_PYTHON="${lib.getExe pkgs.python312}";
    # Prevent uv from downloading managed Python's
    export UV_PYTHON_DOWNLOADS="never"
    uv venv
    bash --rcfile .venv/bin/activate "$@"
  '';
}).env
