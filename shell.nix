{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
  run ? "bash",
}:
let
  inherit (pkgs) lib;
  python = pkgs.python313;
in
(pkgs.buildFHSEnv {
  name = "fsfe-website-env";
  # Installed for host pc only
  targetPkgs =
    pkgs:
    (with pkgs; [
      # For getting python deps
      uv
      # Need to use a nix python to prevent ssl certs issues
      python
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
      # Packages for git hooks
      mediainfo
      perl
      file
      shfmt
      prettier
    ]);
  # Installed for every architecture: only install the lib outputs
  multiPkgs =
    pkgs:
    (with pkgs; [
    ]);
  runScript = pkgs.writeShellScript "fsfe-website-env" ''
    set -euo pipefail
    # Force uv to use Python interpreter from venv
    export UV_PYTHON="${lib.getExe python}";
    # Prevent uv from downloading managed Python's
    export UV_PYTHON_DOWNLOADS="never"
    # Install the venv, clearing old ones
    uv venv --clear
    # install project + dev extras
    uv sync --group dev
    # activate the venv in the *current* shell
    source .venv/bin/activate
    # install your git hooks
    lefthook install
    # hand control over to the caller (or start a shell)
    exec ${run}
  '';
}).env
