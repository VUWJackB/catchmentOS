import os
import subprocess
from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = guess_terminal()

keys = [
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod, "shift"], "Return", lazy.spawn("thunar"), desc="Spawn File Manager"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Spawn rofi drun"),
    Key([mod], "b", lazy.spawn("brave"), desc="Spawn browser"),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
]

groups = []

group_names = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
]

group_labels = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
]

group_layouts = [
    "bsp",
    "bsp",
    "bsp",
    "bsp",
    "bsp",
    "bsp",
    "bsp",
    "bsp",
    "bsp",
    "bsp",
]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        )
    )

for i in groups:
    keys.extend(
        [
            Key([mod], i.name, lazy.group[i.name].toscreen()),
            Key([mod], "Tab", lazy.screen.next_group()),
            Key([mod, "shift"], "Tab", lazy.screen.prev_group()),
            Key(["mod1"], "Tab", lazy.screen.next_group()),
            Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name),
                lazy.group[i.name].toscreen(),
            ),
        ]
    )


layout_options = {"margin": 5, "border_width": 0}


def init_colors():
    return [
        ["#2e3440", "#2e3440"],  # color 0
        ["#373e4d", "#373e4d"],  # color 1
        ["#434c5e", "#434c5e"],  # color 2
        ["#4c566a", "#4c566a"],  # color 3
        ["#d8dee9", "#d8dee9"],  # color 4
        ["#e5e9f0", "#e5e9f0"],  # color 5
        ["#eceff4", "#eceff4"],  # color 6
        ["#88c0d0", "#88c0d0"],  # color 7
        ["#81a1c1", "#81a1c1"],  # color 8
        ["#5e81ac", "#5e81ac"],  # color 9
    ]


colors = init_colors()

layouts = [layout.Bsp(fair=False, **layout_options)]

widget_defaults = dict(
    font="Source Code Pro", fontsize=12, padding=3, background=colors[1]
)
extension_defaults = widget_defaults.copy()


def open_calcurse():
    qtile.cmd_spawn("alacritty -e calcurse")


def open_btm():
    qtile.cmd_spawn("alacritty -e btm")


def open_paru():
    qtile.cmd_spawn("alacritty -e paru -Syu --noconfirm")


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    font="Font Awesome 6 Free",
                    text="   ",
                    foreground=colors[5],
                    fontsize=16,
                    mouse_callbacks={"Button1": lazy.spawn("rofi -show drun")},
                    background=colors[9],
                ),
                widget.Image(
                    filename="~/.config/qtile/round.png",
                    mouse_callbacks={"Button1": lazy.spawn("rofi -show drun")},
                ),
                widget.GroupBox(
                    font="Font Awesome 6 Free",
                    fontsize=16,
                    margin_y=3,
                    margin_x=5,
                    padding_y=0,
                    padding_x=0,
                    borderwidth=0,
                    disable_drag=True,
                    active=colors[9],
                    inactive=colors[5],
                    rounded=False,
                    highlight_method="text",
                    this_current_screen_border=colors[7],
                    background=colors[1],
                ),
                widget.WindowName(
                    font="Source Code Pro",
                    fontsize=16,
                    foreground=colors[5],
                    background=colors[1],
                ),
                widget.Image(filename="~/.config/qtile/power_9.png"),
                widget.TextBox(
                    font="Font Awesome 6 Free",
                    text=" ",
                    foreground=colors[5],
                    fontsize=16,
                    mouse_callbacks={"Button1": open_paru},
                    background=colors[9],
                ),
                widget.CheckUpdates(
                    display_format="{updates}",
                    update_interval=120,
                    distro="Arch_checkupdates",
                    no_update_string="No updates",
                    font="Source Code Pro",
                    fontsize=16,
                    mouse_callbacks={"Button1": open_paru},
                    background=colors[9],
                ),
                widget.Image(
                    filename="~/.config/qtile/power_3.png",
                    background=colors[9],
                ),
                widget.TextBox(
                    font="Font Awesome 6 Free",
                    text=" ",
                    foreground=colors[5],
                    fontsize=16,
                    mouse_callbacks={"Button1": open_btm},
                    background=colors[3],
                ),
                widget.CPU(
                    font="Source Code Pro",
                    format="{load_percent}%",
                    fontsize=16,
                    foreground=colors[5],
                    mouse_callbacks={"Button1": open_btm},
                    background=colors[3],
                ),
                widget.Image(
                    filename="~/.config/qtile/power_9.png",
                    background=colors[3],
                ),
                widget.TextBox(
                    font="Font Awesome 6 Free",
                    text=" ",
                    foreground=colors[5],
                    background=colors[9],
                    padding=0,
                    fontsize=16,
                    mouse_callbacks={"Button1": open_btm},
                ),
                widget.Memory(
                    font="Source Code Pro",
                    format="{MemUsed: .0f}{mm}",
                    update_interval=1,
                    fontsize=16,
                    foreground=colors[5],
                    background=colors[9],
                    mouse_callbacks={"Button1": open_btm},
                ),
                widget.Image(
                    filename="~/.config/qtile/power_3.png",
                    background=colors[9],
                ),
                widget.Systray(
                    background=colors[3],
                    foreground=colors[5],
                    icon_size=20,
                    padding=0,
                    margin=5,
                ),
                widget.Image(
                    filename="~/.config/qtile/power_9.png",
                    background=colors[3],
                ),
                widget.TextBox(
                    font="Font Awesome 6 Free",
                    text=" ",
                    foreground=colors[5],
                    background=colors[9],
                    padding=0,
                    fontsize=16,
                    mouse_callbacks={"Button1": open_calcurse},
                ),
                widget.Clock(
                    font="Source Code Pro",
                    foreground=colors[5],
                    background=colors[9],
                    fontsize=16,
                    format="%d-%m-%Y %H:%M",
                    mouse_callbacks={"Button1": open_calcurse},
                ),
                widget.Image(
                    filename="~/.config/qtile/round_r.png",
                    background=colors[9],
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            "rofi -show power-menu -modi power-menu:rofi-power-menu"
                        )
                    },
                ),
                widget.TextBox(
                    font="Font Awesome 6 Free",
                    text="   ",
                    foreground=colors[5],
                    background="#bf616a",
                    fontsize=16,
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            "rofi -show power-menu -modi power-menu:rofi-power-menu"
                        )
                    },
                ),
            ],
            24,
            margin=[10, 10, 5, 10],
        ),
        bottom=bar.Gap(5),
        left=bar.Gap(5),
        right=bar.Gap(5),
    ),
]

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


wmname = "Qtile"
