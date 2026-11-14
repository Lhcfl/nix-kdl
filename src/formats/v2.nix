let
  inherit (import ../utils.nix) isSpecial;
  inherit (import ./escape.nix) escapeString;
in
import ./base.nix {
  mkKeyword = v: "#" + v;

  mkValue =
    v:
    if builtins.isString v then
      escapeString v
    else if (builtins.typeOf v == "bool" || builtins.typeOf v == "null") then
      "#" + (builtins.toJSON v)
    else
      (builtins.toJSON v);

  mkKey = k: if isSpecial k then escapeString k else k;
}
