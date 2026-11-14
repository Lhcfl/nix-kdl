# Tests for the KDL serialisers. Run with:
#
#   nix eval --raw --file tests
#
# Prints `ok` and exits 0, or throws on the first failing case.
let
  kdl = import ../src/kdl.nix;
  inherit (kdl) formats;

  v1 = nodes: formats.v1 nodes;
  v1val = s: v1 [ (kdl.dsl.n "x" s) ];
  v1key = k: v1 [ (kdl.dsl.n k) ];
  v2val = s: formats.v2 [ (kdl.dsl.n "x" s) ];

  u0001 = builtins.fromJSON ''"\u0001"'';
  u001b = builtins.fromJSON ''"\u001b"'';
  u001f = builtins.fromJSON ''"\u001f"'';

  check = name: expected: actual:
    if expected == actual
    then null
    else
      throw ''
        test `${name}` failed
          expected: ${builtins.toJSON expected}
          actual:   ${builtins.toJSON actual}'';

  checks = [
    # --- string escaping ---------------------------------------------------
    (check "v1 U+0001" ''x "a\u{1}b"'' (v1val "a${u0001}b"))
    (check "v1 U+001B" ''x "a\u{1b}b"'' (v1val "a${u001b}b"))
    (check "v1 U+001F" ''x "a\u{1f}b"'' (v1val "a${u001f}b"))
    (check "v1 newline" ''x "a\nb"'' (v1val "a\nb"))
    (check "v1 tab" ''x "a\tb"'' (v1val "a\tb"))
    (check "v1 quote" ''x "a\"b"'' (v1val "a\"b"))
    (check "v1 backslash" ''x "a\\b"'' (v1val "a\\b"))
    (check "v1 solidus stays literal" ''x "a/b"'' (v1val "a/b"))
    (check "v1 non-ascii stays literal" ''x "中文 é"'' (v1val "中文 é"))
    (check "v1 key with U+0001" ''"a\u{1}b"'' (v1key "a${u0001}b"))
    (check "v2 U+0001" ''x "a\u{1}b"'' (v2val "a${u0001}b"))

    # --- bare identifiers --------------------------------------------------
    (check "bare identifier keeps plus" "Mod+T" (v1key "Mod+T"))
    (check "bare identifier keeps dot" "foo.bar" (v1key "foo.bar"))
    (check "bare identifier keeps unicode" "中文" (v1key "中文"))
    (check "quoted space" ''"a b"'' (v1key "a b"))
    (check "quoted keyword" ''"true"'' (v1key "true"))
    (check "quoted leading digit" ''"1abc"'' (v1key "1abc"))
    (check "quoted signed number" ''"-1"'' (v1key "-1"))
    (check "quoted empty" ''""'' (v1key ""))

    # --- empty children ----------------------------------------------------
    (check "empty body renders a flag" "prefer-no-csd" (v1 [ (kdl.dsl.n "prefer-no-csd" [])]))
    (check "omitted body renders a flag" "prefer-no-csd" (v1 [ (kdl.dsl.n "prefer-no-csd")]))
  ];
in
  builtins.deepSeq checks "ok"
