let
  kdl = import ../src/kdl.nix;
in

# typed type name arg1 arg2 ... parameters body
with kdl.dsl;
kdl.formats.v1 [
  (typed "u8" "some-name" "arg1" 2 3 { key = "value"; } [
    (n "some-untyped-name" "foo" "bar")
    (n "can also be anything")
  ])
]
