let
  kdl = import ../src/kdl.nix;
in
with kdl.dsl;
kdl.formats.v1 [
  (n "give me the fucking raw" (raw "just some (raw) strings"))
]
