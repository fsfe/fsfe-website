{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      forEachSystem =
        let
          systems = [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
          ];
          pkgsFor = lib.attrsets.genAttrs systems (system: import inputs.nixpkgs { inherit system; });
        in
        f: lib.attrsets.genAttrs systems (system: f pkgsFor.${system});
    in
    {
      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
    };
}
