let
  inherit (import ../utils.nix) isSpecial;
in
import ./base.nix {
  mkKeyword = v: v;

  mkValue = builtins.toJSON;

  mkKey = k: if isSpecial k then builtins.toJSON k else k;
}
