{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, binary, bytestring, containers
      , data-binary-ieee754, deepseq, groom, hashable, hspec, QuickCheck
      , stdenv, text, unordered-containers, vector, void
      }:
      mkDerivation {
        pname = "data-msgpack";
        version = "0.0.10";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          base binary bytestring containers data-binary-ieee754 deepseq
          hashable QuickCheck text unordered-containers vector void
        ];
        executableHaskellDepends = [ base bytestring groom ];
        testHaskellDepends = [
          base bytestring containers hashable hspec QuickCheck text
          unordered-containers vector void
        ];
        homepage = "http://msgpack.org/";
        description = "A Haskell implementation of MessagePack";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
