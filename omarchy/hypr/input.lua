-- Caps Lock acts as Control; Right Alt is the compose key.
hl.config({
  input = {
    kb_layout = "us",
    kb_options = "ctrl:nocaps,compose:ralt",

    repeat_rate = 40,
    repeat_delay = 600,
    numlock_by_default = true,

    sensitivity = 0.65,
  },
})
