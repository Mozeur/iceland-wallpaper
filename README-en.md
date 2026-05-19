# 🇮🇸 Iceland Dynamic Wallpaper

> A GNOME dynamic wallpaper — anime-style Icelandic landscape with 8 time-of-day variations.

![preview](preview.png)

## Time of day

| Time | Mood |
|------|------|
| 00:00 – 05:00 | 🌑 Deep night |
| 05:00 – 07:00 | 🌌 Blue night |
| 07:00 – 09:00 | 🌅 Sunrise |
| 09:00 – 12:00 | 🧊 Cold morning |
| 12:00 – 15:00 | ☀️ Noon |
| 15:00 – 18:00 | 🌤️ Afternoon |
| 18:00 – 20:00 | 🌇 Sunset |
| 20:00 – 00:00 | 🌆 Dusk / aurora |

Transitions between phases are smooth (native GNOME overlay crossfade).

## Installation

### Requirements

- GNOME (tested on GNOME 45+)
- `gsettings` available (included by default)

### Quick install

```bash
git clone https://github.com/[your-username]/iceland-wallpaper
cd iceland-wallpaper
chmod +x setup.sh
./setup.sh
```

The script will:
1. Copy the 8 images to `~/.local/share/backgrounds/Iceland/`
2. Generate the dynamic XML with paths adapted to your system
3. Register the wallpaper in GNOME
4. Apply it immediately

### Uninstall

```bash
./setup.sh --uninstall
```

## Project structure

```
iceland-wallpaper/
├── setup.sh          # Install script
├── README.md
└── wallpapers/
    ├── 1.png         # Deep night
    ├── 2.png         # Blue night
    ├── 3.png         # Sunrise
    ├── 4.png         # Cold morning
    ├── 5.png         # Noon
    ├── 6.png         # Afternoon
    ├── 7.png         # Sunset
    └── 8.png         # Dusk / aurora
```

## How it works

GNOME natively supports dynamic wallpapers through an XML file — no daemon,
no cron job, no external dependency. It's handled directly by `gnome-session`.

The `iceland-dynamic.xml` file defines `<static>` blocks (fixed duration)
and `<transition type="overlay">` blocks (crossfade between two images).

## Credits

AI-generated images — inspired by Icelandic landscapes, anime/illustration style.

---

*Posted on [r/unixporn](https://reddit.com/r/unixporn)*
