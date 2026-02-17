# HyprVim Mode Indicator for Waybar

This directory contains two different implementations for displaying HyprVim mode status in Waybar.

## 📋 Summary

Both implementations are now installed and ready to use. You just need to choose which one you prefer!

### Option A: Event-Driven (RECOMMENDED) ⚡
- **Status:** Currently ACTIVE in waybar config
- **Shows:** NORMAL, INSERT, VISUAL, V-LINE modes with icons
- **Response:** Instant (event-driven)
- **Setup:** Requires starting background listener service

### Option B: Polling-Based (SIMPLER) 🔄
- **Status:** Available (commented out in config)
- **Shows:** "VIM ACTIVE" or hidden
- **Response:** ~1 second delay
- **Setup:** No background service needed

---

## 🚀 Quick Start

### Option A: Event-Driven Setup (Currently Active)

**Step 1: Start the listener service**

Choose ONE method:

**Method 1: Using systemd (RECOMMENDED)**
```bash
systemctl --user daemon-reload
systemctl --user enable --now hyprvim-mode-listener.service
```

**Method 2: Add to Hyprland config**
Add to `~/.config/hypr/hyprland.conf`:
```conf
exec-once = ~/.config/waybar/scripts/hyprvim-mode-listener.py
```

**Step 2: Restart Waybar**
```bash
killall waybar && waybar &
```

**Step 3: Test it!**
- Press `Super+Esc` to activate HyprVim NORMAL mode
- The indicator should appear in Waybar showing " NORMAL"
- Press `i` to enter INSERT mode - it should change to " INSERT"
- Press `Esc` to return to NORMAL mode
- Press `Super+Esc` again to exit HyprVim - indicator disappears

---

### Option B: Polling-Based Setup (Alternative)

**Step 1: Edit Waybar config**

Edit `~/.config/waybar/config.jsonc`:

1. **Comment out** Option A module:
```jsonc
// "custom/hyprvim-mode": {
//     "format": "{}",
//     "exec": "~/.config/waybar/scripts/hyprvim-mode.sh",
//     "return-type": "json",
//     "interval": 1,
//     "tooltip": true
// },
```

2. **Uncomment** Option B module:
```jsonc
"custom/hyprvim-mode": {
    "format": "{}",
    "exec": "~/.config/waybar/scripts/hyprvim-mode-polling.sh",
    "return-type": "json",
    "interval": 1,
    "tooltip": true
},
```

**Step 2: Restart Waybar**
```bash
killall waybar && waybar &
```

**Step 3: Test it!**
- Press `Super+Esc` to activate HyprVim
- The indicator should show " VIM" when HyprVim is active
- It will hide when you exit HyprVim

---

## 🎨 Styling

The mode indicator uses Catppuccin colors from your theme:

- **NORMAL Mode:** Blue background (󰘧)
- **INSERT Mode:** Green background (󰗀)
- **VISUAL Mode:** Yellow background (󰘫)
- **V-LINE Mode:** Orange background (󰘫)
- **Hidden:** Completely invisible when not in use

You can customize colors in `~/.config/waybar/style.css` under the section:
```css
/* HyprVim Mode Indicator Styles */
```

---

## 📝 Files Created

### Option A (Event-Driven)
- `hyprvim-mode-listener.py` - Background daemon listening to Hyprland socket2
- `hyprvim-mode.sh` - Waybar script that reads state file
- `~/.config/systemd/user/hyprvim-mode-listener.service` - Systemd service

### Option B (Polling)
- `hyprvim-mode-polling.sh` - Single script that polls for activity

### Configuration
- `~/.config/waybar/config.jsonc` - Updated with both module options
- `~/.config/waybar/style.css` - Added styling for mode indicator

---

## 🔧 Troubleshooting

### Option A: Listener not working

**Check if listener is running:**
```bash
systemctl --user status hyprvim-mode-listener.service
```

**View logs:**
```bash
journalctl --user -u hyprvim-mode-listener.service -f
```

**Check state file:**
```bash
cat $XDG_RUNTIME_DIR/hyprvim/waybar-mode-state.json
```

**Test the display script manually:**
```bash
~/.config/waybar/scripts/hyprvim-mode.sh
```

### Option B: Polling not showing modes

**Test the script manually:**
```bash
~/.config/waybar/scripts/hyprvim-mode-polling.sh
```

**Check hyprvim directory:**
```bash
ls -la $XDG_RUNTIME_DIR/hyprvim/
```

### General Issues

**Waybar not showing module:**
1. Check Waybar config syntax: `jsonc` comments must be valid
2. Restart Waybar: `killall waybar && waybar &`
3. Check Waybar logs for errors

**Icons not displaying:**
- Ensure you have a Nerd Font installed
- Your current font is "JetBrainsMono Nerd Font" which should support these icons

---

## 📊 Comparison Table

| Feature | Option A (Event) | Option B (Polling) |
|---------|-----------------|-------------------|
| **Accuracy** | Perfect | Good |
| **Modes Shown** | NORMAL, INSERT, VISUAL, V-LINE | VIM ACTIVE only |
| **Response Time** | Instant | ~1 second |
| **CPU Usage** | ~5MB RAM daemon | Minimal |
| **Setup Complexity** | Medium | Simple |
| **Dependencies** | Python 3 | None |
| **Reliability** | Very High | High |

---

## 🎯 Recommendations

- **For best experience:** Use Option A (Event-Driven)
  - Accurate mode display
  - Instant updates
  - Professional solution
  
- **For simplicity:** Use Option B (Polling)
  - No background service
  - Good enough for basic indicator
  - Easier to troubleshoot

---

## 📚 How It Works

### Option A: Event-Driven Architecture

1. **Hyprland** broadcasts `submap>>MODE` events to socket2 when mode changes
2. **Listener daemon** (`hyprvim-mode-listener.py`) connects to socket2
3. **State file** gets updated at `$XDG_RUNTIME_DIR/hyprvim/waybar-mode-state.json`
4. **Waybar script** (`hyprvim-mode.sh`) reads state file every second
5. **Waybar** displays the formatted mode indicator

### Option B: Polling Architecture

1. **Waybar** runs script every 1 second
2. **Script** checks various indicators:
   - Active window class (hyprvim windows)
   - Find state file activity
   - Register file modifications
3. **Infers** if HyprVim is active
4. **Waybar** displays "VIM ACTIVE" or hides indicator

---

## 🔄 Switching Between Options

You can easily switch between implementations by editing the Waybar config:

1. Open `~/.config/waybar/config.jsonc`
2. Find the HyprVim section (around line 100)
3. Comment/uncomment the desired option
4. Restart Waybar: `killall waybar && waybar &`

---

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Verify all scripts are executable: `ls -la ~/.config/waybar/scripts/hyprvim-mode*`
3. Test scripts individually to isolate the problem
4. Check Hyprland and Waybar logs

---

**Enjoy your new HyprVim mode indicator!** 🎉
