--
-- rules.lua
-- Client rules
--

local awful = require("awful")
local beautiful = require("beautiful")
local keys = require("keys")
local helpers = require('helpers')

local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height


local rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.clientkeys,
      buttons = keys.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
    }
  },

  -- Pavucontrol & Bluetooth Devices
  {
    rule_any = {
      class = {
        "Pavucontrol",
      },
    },
    properties = {
      width = screen_width * 0.30,
      height = screen_height * 0.50,
    },
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",   -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",
        "Sxiv",
        "Tor Browser",
        "Wpa_gui",
        "veromix",
        "xtightvncviewer",
        "Pavucontrol",
        "plasmashell",
        "Plasma",
      },
      name = {
        "Bluetooth Devices",
        "Event Tester", -- xev.
        "Steam Guard - Computer Authorization Required",
      },
      role = {
        "AlarmWindow",   -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
        "GtkFileChooserDialog",
      },
      type = {
        "dialog",
      },
    },
    properties = {
      placement = awful.placement.centered,
      floating = true,
    },
  },

  -- Remove titlebars to normal clients and dialogs
  {
    rule_any = {
      type = {
        "normal",
        "dialog"
      },
    },
    properties = { titlebars_enabled = false }
  },

  -- Set rules to creates app in proper tags with special properties

  -- Tag #1 [web]
  {
    rule_any = {
      class = {
        "Firefox",
        "Chromium-browser",
        "Google-chrome",
        "Tor Browser",
        "Brave-browser",
        "Links"
      }
    },
    properties = {
      screen = helpers.get_screen("web"),
      tag = "web"
    }
  },
  -- Tag #2 [mail]
  {
    rule_any = {
      class = {
        "Thunderbird",
        "thunderbird"
      },
      name = {
        "mutt"
      }
    },
    properties = {
      screen = helpers.get_screen("mail"),
      tag = "mail",
      switchtotag = true
    }
  },
  -- Tag #3 [dev]
  {
    rule_any = {
      class = {
        "jetbrains-pycharm",
        "jetbrains-pycharm-ce",
        "jetbrains-goland",
        "jetbrains-idea-ce",
        "jetbrains-idea",
        "Code"
      },
      name = {
        "vim_ide"
      }
    },
    properties = {
      screen = helpers.get_screen("dev"),
      tag = "dev",
      switchtotag = true
    }
  },
  -- Tag #4 [shell]
  {
    rule_any = {
      class = {
        "Terminator"
      },
      name = {
        string.format("%s_shell", Apps.terminal)
      }
    },
    properties = {
      screen = helpers.get_screen("shell"),
      tag = "shell",
      switchtotag = true
    }
  },
  -- Tag #5 [talk]
  {
    rule_any = {
      class = {
        "Slack",
        "discord",
        "Telegram"
      }
    },
    properties = {
      screen = helpers.get_screen("talk"),
      tag = "talk",
      switchtotag = true
    }
  },
  -- Tag #6 [desk]
  {
    rule_any = {
      name = {
        "Thunar",
        "ranger"
      }
    },
    properties = {
      screen = helpers.get_screen("desk"),
      tag = "desk",
      switchtotag = true
    }
  },
  -- Tag #7 [media]
  {
    rule_any = {
      class = {
        "Gimp",
        "Openshot",
        "vlc",
        "zoom",
        "Eog",
        "vlc",
        "MOC",
        "mocp_widget",
        "Blender",
        "Sonata",
        "Inkscape",
      },
      name = {
        "Zoom",
        "EasyTAG",
        "mocp",
        "inkscape",
        "ncmpcpp 0.8.2"
      }
    },
    properties = {
      screen = helpers.get_screen("media"),
      tag = "media",
      switchtotag = true
    }
  },
  -- Tag #8 [sys]
  {
    rule_any = {
      name = {
        "Bluetooth Devices",
        "Remmina",
        "System Settings",
        "ProtonVPN"
      },
      class = {
        "QEMU",
        "Virt-manager",
        "VirtualBox",
        "Arandr",
        "Seahorse",
        "Pavucontrol",
        "Nm-applet",
        "Nm-connection-editor",
        "Ibus-setup",
        "protonvpn",
        "cloud-backup-ui"
      }
    },
    properties = {
      screen = helpers.get_screen("sys"),
      tag = "sys",
      switchtotag = true
    }
  },
  -- Tag #9 [games]
  {
    rule_any = {
      name = {
        "Steam",
        "binance"
      },
      class = {
        "steam",
        "Binance"
      }
    },
    properties = {
      screen = helpers.get_screen("games"),
      tag = "games",
      switchtotag = true
    }
  },
}

return rules
