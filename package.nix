{
  stdenv
, lib
, callPackage
, makeWrapper
, nixos-option
, ncurses
, fetchFromGitHub
, version ? "undefined"
, flake-compat ? null
, ...
}:
let
  inherit (lib) makeBinPath;
  inherit (builtins) fetchTarball;

  usedFlakeCompat = if flake-compat == null 
    then fetchFromGitHub {
      owner = "edolstra";
      repo = "flake-compat";
      rev = "12c64ca55c1014cdc1b16ed5a804aa8576601ff2";
      sha256 = "sha256-hY8g6H2KFL8ownSiFeMOjwPC8P0ueXpCVEbxgda3pko=";
    } else flake-compat;

in stdenv.mkDerivation {
  pname = "nix-option";
  inherit version;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    makeWrapper "${./nix-option}" "$out/bin/nix-option" \
      --prefix PATH : "${makeBinPath [ nixos-option ncurses ]}" \
      --prefix FLAKE_COMPAT : "${usedFlakeCompat}"
  '';
  dontUnpack = true;

  meta = with lib; {
    description = "nixos-option, but for the flake era";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
    platforms = nixos-option.meta.platforms;
  };
}
