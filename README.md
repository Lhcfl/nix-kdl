# Better Nix KDL generator

[KDL](https://github.com/kdl-org/kdl) generator written in pure Nix.

Better DSL design. Supports both [KDL v1](https://github.com/kdl-org/kdl/blob/main/SPEC_v1.md) and [KDL v2](https://github.com/kdl-org/kdl/blob/main/draft-marchan-kdl2.md).

# Usage

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