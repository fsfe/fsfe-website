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
    # Python needed for various scripts
    # Python deps handled through requirements.txt
    python312
    python312Packages.pip
    # Needed only for non dev builds. IE --build-env "fsfe.org" or such
    lessc
    # Needed for translation status script
    perl
  ];
  shellHook = '''';
}
