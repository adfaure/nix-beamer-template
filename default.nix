{ pkgs ?
  import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz")
  { } }:

let
  jobs = rec {
    pythonPackages = pkgs.python3Packages;
    buildPythonPackage = pythonPackages.buildPythonPackage;

    slides = pkgs.stdenv.mkDerivation {
      pname = "git-slides";
      version = "0.1.0";
      nativeBuildInputs = with pkgs; [
        texlive.combined.scheme-full
        pandoc
        ninja
        inkscape
        asymptote
        tree
      ];
      src = pkgs.lib.sourceByRegex ./. [
        "^build.ninja$"
        "^fig$"
        "^fig/.*.asy$"
        "^fig/.*.R$"
        "^fig/.*.csv$"
        "^img$"
        "^img/.*.eps"
        "^img/.*.svg"
        "^img/.*.png"
        "^img/.*.pdf"
        "^slides$"
        "^slides/.*.md$"
        "^slides/.*.sty$"
      ];
      buildPhase = ''
        ninja
        tree .
      '';
      installPhase = ''
        mkdir -p $out
        mv slides/slides.pdf $out/
      '';
    };

    autorebuild-shell = pkgs.mkShell rec {
      name = "autobuild-shell";
      buildInputs = [ pkgs.entr pkgs.llpp ] ++ slides.nativeBuildInputs;
      shellHook = ''
        ls build.ninja slides/*.md slides/*.sty fig/*.asy | entr -s "ninja ; killall -HUP --regexp '(.*bin/)?llpp' && exit"
      '';
    };
  };
in jobs
