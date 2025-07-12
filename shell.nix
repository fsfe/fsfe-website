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
    # For getting python deps
    uv
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
  ];
  shellHook = ''
    export UV_SYSTEM_PYTHON=true
  '';
}
