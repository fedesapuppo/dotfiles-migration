-- Omarchy 4.0.4 exports LIBVA_DRIVER_NAME=nvidia on every NVIDIA machine. On a
-- hybrid laptop the iGPU drives the panel and cannot show NVIDIA-decoded frames
-- (black video in Chromium). Master already gates this on the display GPU, so
-- this override only runs while NVIDIA is not the boot VGA device.
local nvidia_drives_display = o.shell_succeeds(
  "grep -lx 1 /sys/bus/pci/devices/*/boot_vga | xargs -r dirname | xargs -r -I{} cat {}/vendor | grep -q 0x10de"
)
if not nvidia_drives_display then
  hl.env("LIBVA_DRIVER_NAME", "radeonsi")
end
