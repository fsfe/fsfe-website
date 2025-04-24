{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
let
  treefmt-nixSrc = builtins.fetchTarball "https://github.com/numtide/treefmt-nix/archive/refs/heads/master.tar.gz";
  treefmt-nix = import treefmt-nixSrc;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # The main required tool python
    python3
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
  ];
  shellHook = ''
    export PIP_DISABLE_PIP_VERSION_CHECK=1;
    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
  '';
}
