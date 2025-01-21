{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # Needed for standard build
    coreutils
    findutils
    gnused
    gnugrep
    gnumake
    rsync
    libxslt
    libxml2
    iconv
    wget
    # We use uv to run scripts
    # We still install python using nix to avoid issues with dynamic linked pythons from up
    python312
    uv
    # For less compilation
    lessc
    # Needed for translation status script
    perl
    # For checking python
    ruff
  ];
  shellHook = ''
  # Force uv to use the nix python instead of installing its own
  UV_SYSTEM_PYTHON=true    
  '';
}
