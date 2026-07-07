let
  kdl = import ../src/kdl.nix;
in
with kdl.extras.niri;
kdl.formats.v1 [
  (input [
    (keyboard [
      (xkb [
        (layout "us")
      ])
    ])
    (touchpad [
      tap
      natural-scroll
      dwt
    ])
    workspace-auto-back-and-forth
    (mod-key "Super")
    (mod-key-nested "Super")
  ])
  (environment [
    (n "QT_QPA_PLATFORM" "wayland")
  ])
  (xwayland-satellite [
    (n "path" "/run/current-system/sw/bin/xwayland-satellite")
  ])
  (cursor [
    (xcursor-size 24)
    hide-when-typing
  ])
  (hotkey-overlay [
    skip-at-startup
  ])
  (blur [
    (passes 3)
    (offset 3.0)
    (noise 0.02)
    (saturation 1.5)
  ])
]

# It will generates:
#
# input {
#     keyboard {
#         xkb {
#             layout "us"
#         }
#     }
#     touchpad {
#         tap
#         natural-scroll
#         dwt
#     }
#     workspace-auto-back-and-forth
#     mod-key "Super"
#     mod-key-nested "Super"
# }
# environment {
#     QT_QPA_PLATFORM "wayland"
# }
# xwayland-satellite {
#     path "/run/current-system/sw/bin/xwayland-satellite"
# }
# cursor {
#     xcursor-size 24
#     hide-when-typing
# }
# hotkey-overlay {
#     skip-at-startup
# }
# blur {
#     passes 3
#     offset 3.0
#     noise 0.02
#     saturation 1.5
# }
