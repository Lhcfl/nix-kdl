let
  kdl = import ../src/kdl.nix;

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
