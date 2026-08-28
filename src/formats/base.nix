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

  mkNode =
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
    if body == null then [ head ] else [ "${head} {" ] ++ mkBody true body ++ [ "}" ];
in
x: builtins.concatStringsSep "\n" (mkBody false x)
