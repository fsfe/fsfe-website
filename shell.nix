{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
  run ? "bash",
}:
let
  inherit (pkgs) lib;
  python = pkgs.python314;
  name = "fsfe-website-env";
in
(pkgs.buildFHSEnv {
  inherit name;
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
      shfmt
      prettier
      php84Packages.php-cs-fixer
      rsync
      # drone cli for signing
      drone-cli
    ]);
  # Installed for every architecture: only install the lib outputs
  multiPkgs = pkgs: (with pkgs; [ ]);
  runScript = pkgs.writeShellScript name ''
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
    # Source .env for providing vars
    if [[ -f .env ]]; then
      set -o allexport
      source .env
      set +o allexport
    fi
    # hand control over to the caller (or start a shell)
    exec ${run}
  '';
}).env
