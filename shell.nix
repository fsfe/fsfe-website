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
    # Needed for the site index script
    python312
    python312Packages.beautifulsoup4
    # Needed only for non dev builds. IE --build-env "fsfe.org" or such
    lessc
    # Needed for translation status script
    perl
  ];
}
