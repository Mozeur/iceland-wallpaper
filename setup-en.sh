#!/usr/bin/env bash
# =============================================================================
#  Iceland Dynamic Wallpaper — GNOME Setup Script
#  https://github.com/[your-username]/iceland-wallpaper
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Paths ─────────────────────────────────────────────────────────────────────
WALLPAPER_DIR="$HOME/.local/share/backgrounds/iceland-wallpaper"
GNOME_PROPS_DIR="$HOME/.local/share/gnome-background-properties"
DYNAMIC_XML="$WALLPAPER_DIR/iceland-dynamic.xml"
GNOME_XML="$GNOME_PROPS_DIR/iceland.xml"

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { echo -e "${CYAN}${BOLD}::${RESET} $*"; }
success() { echo -e "${GREEN}${BOLD}✔${RESET}  $*"; }
error()   { echo -e "${RED}${BOLD}✘${RESET}  $*" >&2; exit 1; }
step()    { echo -e "\n${BLUE}${BOLD}▶ $*${RESET}"; }

# ── Checks ────────────────────────────────────────────────────────────────────
check_dependencies() {
  step "Checking dependencies"

  command -v gsettings &>/dev/null \
    || error "gsettings not found — are you running GNOME?"

  [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] \
    || echo -e "${RED}Warning:${RESET} Desktop detected: ${XDG_CURRENT_DESKTOP:-unknown} (GNOME recommended)"

  success "Dependencies OK"
}

# ── Copy wallpapers ───────────────────────────────────────────────────────────
install_wallpapers() {
  step "Installing wallpapers"

  local source_dir
  source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/wallpapers"

  [[ -d "$source_dir" ]] \
    || error "No 'wallpapers/' folder found next to the script.\n   Place the 8 PNG files (1.png → 8.png) inside wallpapers/"

  local count
  count=$(find "$source_dir" -name "*.png" | wc -l)
  [[ "$count" -eq 8 ]] \
    || error "Expected 8 PNG files in wallpapers/, found $count"

  mkdir -p "$WALLPAPER_DIR"
  cp "$source_dir"/{1..8}.png "$WALLPAPER_DIR/"
  success "8 images copied → $WALLPAPER_DIR"
}

# ── Generate dynamic XML ──────────────────────────────────────────────────────
generate_dynamic_xml() {
  step "Generating dynamic XML"

  mkdir -p "$WALLPAPER_DIR"

  cat > "$DYNAMIC_XML" << EOF
<background>
  <starttime>
    <year>2024</year>
    <month>1</month>
    <day>1</day>
    <hour>0</hour>
    <minute>0</minute>
    <second>0</second>
  </starttime>

  <!-- 00:00 → 05:00 : Deep night (4h static + 1h transition) -->
  <static>
    <duration>14400</duration>
    <file>$WALLPAPER_DIR/1.png</file>
  </static>
  <transition type="overlay">
    <duration>3600</duration>
    <from>$WALLPAPER_DIR/1.png</from>
    <to>$WALLPAPER_DIR/2.png</to>
  </transition>

  <!-- 05:00 → 07:00 : Blue night (1h static + 1h transition) -->
  <static>
    <duration>3600</duration>
    <file>$WALLPAPER_DIR/2.png</file>
  </static>
  <transition type="overlay">
    <duration>3600</duration>
    <from>$WALLPAPER_DIR/2.png</from>
    <to>$WALLPAPER_DIR/3.png</to>
  </transition>

  <!-- 07:00 → 09:00 : Sunrise (1h static + 1h transition) -->
  <static>
    <duration>3600</duration>
    <file>$WALLPAPER_DIR/3.png</file>
  </static>
  <transition type="overlay">
    <duration>3600</duration>
    <from>$WALLPAPER_DIR/3.png</from>
    <to>$WALLPAPER_DIR/4.png</to>
  </transition>

  <!-- 09:00 → 12:00 : Cold morning (2h30 static + 30min transition) -->
  <static>
    <duration>9000</duration>
    <file>$WALLPAPER_DIR/4.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/4.png</from>
    <to>$WALLPAPER_DIR/5.png</to>
  </transition>

  <!-- 12:00 → 15:00 : Noon (2h30 static + 30min transition) -->
  <static>
    <duration>9000</duration>
    <file>$WALLPAPER_DIR/5.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/5.png</from>
    <to>$WALLPAPER_DIR/6.png</to>
  </transition>

  <!-- 15:00 → 18:00 : Afternoon (2h30 static + 30min transition) -->
  <static>
    <duration>9000</duration>
    <file>$WALLPAPER_DIR/6.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/6.png</from>
    <to>$WALLPAPER_DIR/7.png</to>
  </transition>

  <!-- 18:00 → 20:00 : Sunset (1h30 static + 30min transition) -->
  <static>
    <duration>5400</duration>
    <file>$WALLPAPER_DIR/7.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/7.png</from>
    <to>$WALLPAPER_DIR/8.png</to>
  </transition>

  <!-- 20:00 → 00:00 : Dusk / aurora (3h30 static + 30min transition) -->
  <static>
    <duration>12600</duration>
    <file>$WALLPAPER_DIR/8.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/8.png</from>
    <to>$WALLPAPER_DIR/1.png</to>
  </transition>

</background>
EOF

  success "Dynamic XML generated → $DYNAMIC_XML"
}

# ── Register in GNOME ─────────────────────────────────────────────────────────
register_gnome() {
  step "Registering wallpaper in GNOME"

  mkdir -p "$GNOME_PROPS_DIR"

  cat > "$GNOME_XML" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<wallpapers>
  <wallpaper deleted="false">
    <name>Iceland Dynamic</name>
    <filename>$DYNAMIC_XML</filename>
    <options>zoom</options>
    <pcolor>#000000</pcolor>
    <scolor>#000000</scolor>
  </wallpaper>
</wallpapers>
EOF

  success "Wallpaper registered in GNOME → $GNOME_XML"
}

# ── Apply wallpaper ───────────────────────────────────────────────────────────
apply_wallpaper() {
  step "Applying wallpaper"

  gsettings set org.gnome.desktop.background picture-uri \
    "file://$DYNAMIC_XML"
  gsettings set org.gnome.desktop.background picture-uri-dark \
    "file://$DYNAMIC_XML"
  gsettings set org.gnome.desktop.background picture-options "zoom"

  success "Wallpaper applied!"
}

# ── Uninstall ─────────────────────────────────────────────────────────────────
uninstall() {
  step "Uninstalling"
  rm -rf "$WALLPAPER_DIR" "$GNOME_XML"
  gsettings reset org.gnome.desktop.background picture-uri
  gsettings reset org.gnome.desktop.background picture-uri-dark
  success "Wallpaper removed"
  exit 0
}

# ── Summary ───────────────────────────────────────────────────────────────────
print_summary() {
  echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD}  ✔  Iceland Dynamic Wallpaper installed!${RESET}"
  echo -e "${GREEN}${BOLD}══════════════════════════════════════════${RESET}"
  echo -e "  The wallpaper will change automatically"
  echo -e "  based on the time of day.\n"
  echo -e "  You can also select it manually in"
  echo -e "  ${BOLD}Settings → Background${RESET}\n"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  echo -e "\n${BOLD}Iceland Dynamic Wallpaper — Setup${RESET}"
  echo -e "Time-of-day anime wallpaper for GNOME\n"

  [[ "${1:-}" == "--uninstall" ]] && uninstall

  check_dependencies
  install_wallpapers
  generate_dynamic_xml
  register_gnome
  apply_wallpaper
  print_summary
}

main "$@"
