# Better Nix KDL generator

[KDL](https://github.com/kdl-org/kdl) generator written in pure Nix.

Better DSL design. Supports both [KDL v1](https://github.com/kdl-org/kdl/blob/main/SPEC_v1.md) and [KDL v2](https://github.com/kdl-org/kdl/blob/main/draft-marchan-kdl2.md).

## Technical Details

A KDL node consists of five parts: type, name, parameters, arguments, and body. The body itself is a collection of KDL nodes. Parameters are key-value pairs.

KDL supports only four types of values: boolean, null, string, and integer. It does not support arrays or hash maps. Therefore, a hash map can safely be treated as parameters, while an array can be treated as the body.

We provide two ways to declare nodes: `n` and `typed`.

```nix
# typed type name arg1 arg2 ... parameters body
with kdl.dsl; kdl.formats.v1 [
    (typed "u8" "some-name" "arg1" 2 3 { key="value"; } [
        (n "some-untyped-name" "foo" "bar")
        (n "can also be anything")
    ])
]
```

```kdl
(u8)some-name "arg1" 2 3 key="value" {
    some-untyped-name "foo" "bar"
    "can also be anything"
}
```

We also provide `raw` to force generate a raw value, like:

```nix
with kdl.dsl; kdl.formats.v1 [
    (n "give me the fucking raw" (raw "just some (raw) strings"))
]
```

```kdl
"give me the fucking raw" just some (raw) strings
```

## Usage

```nix
let
  kdl = inputs.kdl

  data = with kdl.dsl; [
    (n "spawn-at-startup" "fcitx5" "q" "w" "q")
    (n "prefer-no-csd")
    (n "workspace-shadow" [
      (n "softness" 40)
      (n "offset" {
        x = 0;
        y = 10;
      })
      (n "color" "#00000050")
    ])
    (n "window-rule" [
      (n "match" { is-floating = true; })
      (n "backend-effect" [
        (n "xray" false)
      ])
    ])
    (n "binds" [
      (n "Mod+WheelScrollDown" { cooldown-ms = 150; } [
        (n "focus-workspace-down")
      ])
    ])
    (n "example-raw" (raw "+inf"))
    (n "example-keyword" keywords.inf)
    (n "example-keyword" true)
    (n "example-keyword" null)
    (n "strange key")
    (n "[miao] key")
    (n "中文" null)
    (n "true" null)
    (n "inf" null)
    (n "(not)a-type" null)
    (typed "u8" "is-a-type" null)
    (typed "(strange type name)" "strange key name" null)
  ];
in
with kdl;
"======== v2 ========\n" + (formats.v2 data) + "\n\n========= v1 =========\n" + (formats.v1 data)
```

it will outputs:

```kdl
======== v2 ========
spawn-at-startup "fcitx5" "q" "w" "q"
prefer-no-csd
workspace-shadow {
    softness 40
    offset x=0 y=10
    color "#00000050"
}
window-rule {
    match is-floating=#true
    backend-effect {
        xray #false
    }
}
binds {
    "Mod+WheelScrollDown" cooldown-ms=150 {
        focus-workspace-down
    }
}
example-raw +inf
example-keyword #inf
example-keyword #true
example-keyword #null
"strange key"
"[miao] key"
"中文" #null
"true" #null
"inf" #null
"(not)a-type" #null
(u8)is-a-type #null
("(strange type name)")"strange key name" #null

========= v1 =========
spawn-at-startup "fcitx5" "q" "w" "q"
prefer-no-csd
workspace-shadow {
    softness 40
    offset x=0 y=10
    color "#00000050"
}
window-rule {
    match is-floating=true
    backend-effect {
        xray false
    }
}
binds {
    "Mod+WheelScrollDown" cooldown-ms=150 {
        focus-workspace-down
    }
}
example-raw +inf
example-keyword inf
example-keyword true
example-keyword null
"strange key"
"[miao] key"
"中文" null
"true" null
"inf" null
"(not)a-type" null
(u8)is-a-type null
("(strange type name)")"strange key name" null
```

## Extra DSLs

see [examples/niri.nix](./examples/niri.nix)