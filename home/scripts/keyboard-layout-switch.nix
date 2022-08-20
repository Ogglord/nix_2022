{ pkgs, ...}:

let
  xkbmap = "${pkgs.xorg.setxkbmap}/bin/setxkbmap";
  rg     = "${pkgs.ripgrep}/bin/rg";
in
  pkgs.writeShellScriptBin "kls" ''
    layout=$(${xkbmap} -query | ${rg} layout)

    if [[ $layout == *"se"* ]]; then
      ${xkbmap} -layout us
    else
      ${xkbmap} -layout se
    fi
  ''
