# Escaper for KDL quoted strings, shared by the v1 and v2 backends.
#
# `builtins.toJSON` cannot be used here: JSON and KDL do not share the same
# escape set. For control characters without a short escape JSON emits
# `\uXXXX` (exactly four hex digits), while KDL only accepts `\u{...}` (one to
# six hex digits), so such strings produced documents that parsers reject.
#
# Both specs accept every escape emitted below:
#   \" \\ \b \t \n \f \r \u{...}
# (v1 additionally allows `\/` and v2 adds `\s`, but neither is ever needed.)
# Everything else is written as a literal UTF-8 character.
let
  inherit (builtins)
    concatStringsSep
    elemAt
    fromJSON
    genList
    listToAttrs
    stringLength
    substring
    ;

  hexDigit = i: elemAt [
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "a"
    "b"
    "c"
    "d"
    "e"
    "f"
  ] i;

  # Lowercase hex without padding, used for `\u{...}`.
  hex = i:
    if i < 16
    then hexDigit i
    else hex (i / 16) + hexDigit (i - i / 16 * 16);

  # Two digits, used to build the JSON escape below.
  hex2 = i: hexDigit (i / 16) + hexDigit (i - i / 16 * 16);

  # The raw character for a code point < 0x20. `builtins` has no chr(), but a
  # JSON decode gives us one. U+0000 is skipped on purpose: a Nix string cannot
  # contain a null byte, so it can never appear in a value either.
  char = i: fromJSON "\"\\u00${hex2 i}\"";

  # Code points that have a dedicated escape.
  named = {
    "8" = "\\b";
    "9" = "\\t";
    "10" = "\\n";
    "12" = "\\f";
    "13" = "\\r";
  };

  escapes =
    listToAttrs (map (i: {
      name = char i;
      value = named.${toString i} or "\\u{${hex i}}";
    }) (genList (i: i + 1) 31))
    // {
      "\"" = "\\\"";
      "\\" = "\\\\";
    };

  # Byte-wise splitting is fine here: every byte of a multi-byte UTF-8 sequence
  # is >= 0x80, so it never matches a key of `escapes` and passes through
  # unchanged, leaving the original encoding intact.
  bytes = s: genList (i: substring i 1 s) (stringLength s);
in {
  escapeString = s: "\"${concatStringsSep "" (map (c: escapes.${c} or c) (bytes s))}\"";

  # Every C0 control character (U+0001..U+001F). KDL forbids them as literal
  # characters, so anything containing one has to be quoted and escaped.
  controlChars = map char (genList (i: i + 1) 31);
}
