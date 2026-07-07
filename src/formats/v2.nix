let
  inherit (import ../utils.nix) isSpecial;
in
import ./base.nix {
  mkKeyword = v: "#" + v;

  mkValue =
    v:
    if (builtins.typeOf v == "bool" || builtins.typeOf v == "null") then
      "#" + (builtins.toJSON v)
    else
      (builtins.toJSON v);

  mkKey = k: if isSpecial k then builtins.toJSON k else k;
}
