rec {
  pipe = builtins.foldl' (x: f: f x);

  isKeyword =
    x: x == "true" || x == "false" || x == "null" || x == "inf" || x == "-inf" || x == "nan";

  # Characters that may not appear in a bare identifier (SPEC_v1 -> Bare
  # Identifier: everything except whitespace and `\/(){}<>;[]=,"`), plus the C0
  # control characters, which may not appear unescaped anywhere. Spelled out
  # instead of using a regex character class, because the escapes inside a class
  # are not portable across the regex dialects `builtins.match` may use.
  nonIdentifierChars =
    [
      " "
      "\\"
      "/"
      "("
      ")"
      "{"
      "}"
      "<"
      ">"
      ";"
      "["
      "]"
      "="
      ","
      "\""
    ]
    ++ (import ./formats/escape.nix).controlChars;

  # Removes every character that may not appear in a bare identifier, so a
  # string is bare-safe when it comes back unchanged.
  removeNonIdentifierChars =
    builtins.replaceStrings nonIdentifierChars (builtins.genList (_: "") (builtins.length nonIdentifierChars));

  # SPEC_v1 -> Bare Identifier: any characters except whitespace and
  # `\/(){}<>;[]=,"`. A bare identifier may not be a keyword either, may not
  # start with a digit, and may only start with `+`/`-` when no digit follows.
  isBareIdentifier = x:
    x != ""
    && removeNonIdentifierChars x == x
    && builtins.match "[0-9].*" x == null
    && builtins.match "[+-][0-9].*" x == null;

  # Everything that cannot be written bare has to be quoted instead.
  isSpecial = x: !isBareIdentifier x || isKeyword x;
}
