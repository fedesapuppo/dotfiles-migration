-- Mirror the X11 clipboard into Wayland for XWayland apps (gitk and friends).
o.launch_on_start("$HOME/.local/bin/x11-clipboard-sync")
