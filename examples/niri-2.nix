{ inputs, lib, ... }:
{
  xdg.configFile."niri/hm-generated.kdl".text =
    with inputs.nix-kdl.kdl.extras.niri;
    let
      workspace-action = id: [
        (n "Mod+${toString id}" [
          (focus-workspace id)
        ])
        (n "Mod+Shift+${toString id}" [
          (move-column-to-workspace id)
        ])
      ];
    in
    inputs.nix-kdl.kdl.formats.v1 [
      (binds (
        lib.flatten [
          (map workspace-action (builtins.genList (x: x + 1) 9))
          (n "Mod+N" [
            (focus-workspace 255)
          ])
          (n "Mod+Shift+N" [
            (move-column-to-workspace 255)
          ])
          (n "Mod+Left" [
            focus-column-left
          ])
          (n "Mod+Right" [
            focus-column-right
          ])
          (n "Mod+Up" [
            focus-window-up
          ])
          (n "Mod+Down" [
            focus-window-down
          ])
          (n "Mod+Shift+Left" [
            move-column-left
          ])
          (n "Mod+Shift+Right" [
            move-column-right
          ])
          (n "Mod+Shift+Up" [
            move-window-to-workspace-up
          ])
          (n "Mod+Shift+Down" [
            move-window-to-workspace-down
          ])
        ]
      ))
    ];
}

# Will generates
# binds {
#     "Mod+1" {
#         focus-workspace 1
#     }
#     "Mod+Shift+1" {
#         move-column-to-workspace 1
#     }
#     "Mod+2" {
#         focus-workspace 2
#     }
#     "Mod+Shift+2" {
#         move-column-to-workspace 2
#     }
#     "Mod+3" {
#         focus-workspace 3
#     }
#     "Mod+Shift+3" {
#         move-column-to-workspace 3
#     }
#     "Mod+4" {
#         focus-workspace 4
#     }
#     "Mod+Shift+4" {
#         move-column-to-workspace 4
#     }
#     "Mod+5" {
#         focus-workspace 5
#     }
#     "Mod+Shift+5" {
#         move-column-to-workspace 5
#     }
#     "Mod+6" {
#         focus-workspace 6
#     }
#     "Mod+Shift+6" {
#         move-column-to-workspace 6
#     }
#     "Mod+7" {
#         focus-workspace 7
#     }
#     "Mod+Shift+7" {
#         move-column-to-workspace 7
#     }
#     "Mod+8" {
#         focus-workspace 8
#     }
#     "Mod+Shift+8" {
#         move-column-to-workspace 8
#     }
#     "Mod+9" {
#         focus-workspace 9
#     }
#     "Mod+Shift+9" {
#         move-column-to-workspace 9
#     }
#     "Mod+N" {
#         focus-workspace 255
#     }
#     "Mod+Shift+N" {
#         move-column-to-workspace 255
#     }
#     "Mod+Left" {
#         focus-column-left
#     }
#     "Mod+Right" {
#         focus-column-right
#     }
#     "Mod+Up" {
#         focus-window-up
#     }
#     "Mod+Down" {
#         focus-window-down
#     }
#     "Mod+Shift+Left" {
#         move-column-left
#     }
#     "Mod+Shift+Right" {
#         move-column-right
#     }
#     "Mod+Shift+Up" {
#         move-window-to-workspace-up
#     }
#     "Mod+Shift+Down" {
#         move-window-to-workspace-down
#     }
# }
