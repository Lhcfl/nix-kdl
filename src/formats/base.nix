{
  mkValue,
  mkKey,
  mkKeyword,
}:
let
  inherit ((import ../dsl.nix).internal) is-special kinds;
  inherit (import ../utils.nix) pipe;

  mkValue' =
    x:
    if is-special kinds.raw x then
      x.data
    else if is-special kinds.keyword x then
      mkKeyword x.data
    else
      mkValue x;

  mkBody =
    indent: x:
    let
      indented = if indent then x: ("    " + x) else x: x;
    in
    pipe x [
      (map mkNode)
      (builtins.concatLists)
      (map indented)
    ];

  mkParameters =
    obj:
    pipe obj [
      builtins.attrNames
      (map (key: "${mkKey key}=${mkValue' obj.${key}}"))
    ];

  mkNode' =
    {
      type,
      name,
      arguments,
      parameters,
      body,
      ...
    }:
    let
      head = builtins.concatStringsSep " " (
        [
          (if type == null then mkKey name else "(${mkKey type})${mkKey name}")
        ]
        ++ (map mkValue' arguments)
        ++ (mkParameters parameters)
      );
    in
    # An empty children list means "no children": emit a plain node instead of an
    # empty `{}` block, which is what `(n "foo")` already produces.
    if body == null || body == [ ] then [ head ] else [ "${head} {" ] ++ mkBody true body ++ [ "}" ];

  mkNode =
    x:
    if x ? name then
      mkNode' x
    # support lib.mkIf for conditional nodes
    else if (x._type or null == "if") then
      if x.condition then mkNode x.content else [ ]
    # support raw nodes
    else if is-special kinds.raw x then
      [ x.data ]
    else
      throw "Invalid node: ${builtins.toJSON x}";

in
x: builtins.concatStringsSep "\n" (mkBody false x)
