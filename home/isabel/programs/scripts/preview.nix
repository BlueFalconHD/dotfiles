{
  lib,
  pkgs,
  inputs',
  ...
}: ''
  # modified from Elkowar

  case "$1" in
    -*) exit 0;;
  esac

  case "$(${lib.getExe pkgs.file} --mime-type "$1")" in
    *text*)
      ${lib.getExe pkgs.bat} --color always --plain "$1"
      ;;
    *image*)
      ${lib.getExe inputs'.icat-wrapper.packages.default} "$1"
      ;;
    *pdf)
      ${lib.getExe pkgs.catimg} -w 100 -r 2 "$1"
      ;;
    *directory*)
      ${lib.getExe pkgs.eza} --icons -1 --color=always "$1"
      ;;
    *)
      echo "unknown file format"
      ;;
  esac
''
