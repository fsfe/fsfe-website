{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # The main required tool python
    python3
    # needed by lxml
    libxslt
    libxml2
    # For less compilation
    lessc
    # Needed for translation status script
    perl
    # For checking python
    ruff
  ];
  shellHook = ''
    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
  '';
}
