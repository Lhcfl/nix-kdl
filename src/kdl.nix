let
  inherit (import ./utils.nix) pipe;
in
{
  dsl = (import ./dsl.nix).exports;
  extras = pipe ./extra [
    builtins.readDir
    builtins.attrNames
    (map (f: {
      k = builtins.replaceStrings [ ".nix" ] [ "" ] f;
      v = import ./extra/${f};
    }))
    (builtins.foldl' (acc: { k, v }: acc // { ${k} = v; }) { })
  ];
  formats = {
    v2 = import ./formats/v2.nix;
    v1 = import ./formats/v1.nix;
  };
}
