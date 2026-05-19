-- Omarchy-style global hotkeys for macOS
-- Mapped from Hyprland bindings to Hammerspoon

local function launch(app)
  hs.application.launchOrFocus(app)
end

local function openURL(url)
  hs.execute('open "' .. url .. '"')
end

local function launchAlacrittyTmux()
  hs.execute('open -a Alacritty --args -e tmux new')
end

-- Cmd + Return → Alacritty (new window if already running)
hs.hotkey.bind({"cmd"}, "return", function()
  local app = hs.application.find("Alacritty")
  if app then
    hs.execute("open -na Alacritty")
  else
    launch("Alacritty")
  end
end)

-- Cmd + Option + Return → Alacritty + tmux
hs.hotkey.bind({"cmd", "alt"}, "return", function() launchAlacrittyTmux() end)

-- Cmd + Shift + Return → Chrome
hs.hotkey.bind({"cmd", "shift"}, "return", function() launch("Google Chrome") end)

-- Cmd + Shift + O → Obsidian
hs.hotkey.bind({"cmd", "shift"}, "O", function() launch("Obsidian") end)

-- Cmd + Shift + Option + G → WhatsApp
hs.hotkey.bind({"cmd", "shift", "alt"}, "G", function() launch("WhatsApp") end)

-- Cmd + Shift + N → VS Code
hs.hotkey.bind({"cmd", "shift"}, "N", function() launch("Visual Studio Code") end)

-- Cmd + Shift + E → Outlook
hs.hotkey.bind({"cmd", "shift"}, "E", function() launch("Microsoft Outlook") end)

-- Cmd + Shift + Y → YouTube (browser)
hs.hotkey.bind({"cmd", "shift"}, "Y", function() openURL("https://youtube.com/") end)

-- Cmd + Shift + X → X/Twitter (browser)
hs.hotkey.bind({"cmd", "shift"}, "X", function() openURL("https://x.com/") end)

-- Cmd + Shift + P → Photos (Apple)
hs.hotkey.bind({"cmd", "shift"}, "P", function() launch("Photos") end)

-- Cmd + Shift + D → Docker Desktop
hs.hotkey.bind({"cmd", "shift"}, "D", function() launch("Docker") end)
