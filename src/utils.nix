rec {
  pipe = builtins.foldl' (x: f: f x);

  isKeyword =
    x: x == "true" || x == "false" || x == "null" || x == "inf" || x == "-inf" || x == "nan";

  isSpecial = x: (builtins.match "^[a-zA-Z_]+[a-zA-Z0-9_\\-]*$" x) == null || isKeyword x;
}
