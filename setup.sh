#!/usr/bin/env bash
# =============================================================================
#  Islande Dynamic Wallpaper — GNOME Setup Script
#  https://github.com/[ton-pseudo]/islande-wallpaper
# =============================================================================

set -euo pipefail

# ── Couleurs ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Chemins ───────────────────────────────────────────────────────────────────
WALLPAPER_DIR="$HOME/.local/share/backgrounds/islande-wallpaper"
GNOME_PROPS_DIR="$HOME/.local/share/gnome-background-properties"
DYNAMIC_XML="$WALLPAPER_DIR/islande-dynamic.xml"
GNOME_XML="$GNOME_PROPS_DIR/islande.xml"

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { echo -e "${CYAN}${BOLD}::${RESET} $*"; }
success() { echo -e "${GREEN}${BOLD}✔${RESET}  $*"; }
error()   { echo -e "${RED}${BOLD}✘${RESET}  $*" >&2; exit 1; }
step()    { echo -e "\n${BLUE}${BOLD}▶ $*${RESET}"; }

# ── Vérifications ─────────────────────────────────────────────────────────────
check_dependencies() {
  step "Vérification des dépendances"

  command -v gsettings &>/dev/null \
    || error "gsettings introuvable — es-tu bien sous GNOME ?"

  [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] \
    || echo -e "${RED}Attention :${RESET} Desktop détecté : ${XDG_CURRENT_DESKTOP:-inconnu} (GNOME recommandé)"

  success "Dépendances OK"
}

# ── Copie des images ──────────────────────────────────────────────────────────
install_wallpapers() {
  step "Installation des wallpapers"

  local source_dir
  source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/wallpapers"

  [[ -d "$source_dir" ]] \
    || error "Dossier 'wallpapers/' introuvable à côté du script.\n   Place les 8 fichiers PNG (1.png → 8.png) dans wallpapers/"

  local count
  count=$(find "$source_dir" -name "*.png" | wc -l)
  [[ "$count" -eq 8 ]] \
    || error "8 fichiers PNG attendus dans wallpapers/, $count trouvé(s)"

  mkdir -p "$WALLPAPER_DIR"
  cp "$source_dir"/{1..8}.png "$WALLPAPER_DIR/"
  success "8 images copiées → $WALLPAPER_DIR"
}

# ── Génération du XML dynamique ───────────────────────────────────────────────
generate_dynamic_xml() {
  step "Génération du XML dynamique"

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

  <!-- 00h00 → 05h00 : Nuit profonde (4h fixe + 1h transition) -->
  <static>
    <duration>14400</duration>
    <file>$WALLPAPER_DIR/1.png</file>
  </static>
  <transition type="overlay">
    <duration>3600</duration>
    <from>$WALLPAPER_DIR/1.png</from>
    <to>$WALLPAPER_DIR/2.png</to>
  </transition>

  <!-- 05h00 → 07h00 : Nuit bleue (1h fixe + 1h transition) -->
  <static>
    <duration>3600</duration>
    <file>$WALLPAPER_DIR/2.png</file>
  </static>
  <transition type="overlay">
    <duration>3600</duration>
    <from>$WALLPAPER_DIR/2.png</from>
    <to>$WALLPAPER_DIR/3.png</to>
  </transition>

  <!-- 07h00 → 09h00 : Lever de soleil (1h fixe + 1h transition) -->
  <static>
    <duration>3600</duration>
    <file>$WALLPAPER_DIR/3.png</file>
  </static>
  <transition type="overlay">
    <duration>3600</duration>
    <from>$WALLPAPER_DIR/3.png</from>
    <to>$WALLPAPER_DIR/4.png</to>
  </transition>

  <!-- 09h00 → 12h00 : Matin froid (2h30 fixe + 30min transition) -->
  <static>
    <duration>9000</duration>
    <file>$WALLPAPER_DIR/4.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/4.png</from>
    <to>$WALLPAPER_DIR/5.png</to>
  </transition>

  <!-- 12h00 → 15h00 : Midi (2h30 fixe + 30min transition) -->
  <static>
    <duration>9000</duration>
    <file>$WALLPAPER_DIR/5.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/5.png</from>
    <to>$WALLPAPER_DIR/6.png</to>
  </transition>

  <!-- 15h00 → 18h00 : Après-midi (2h30 fixe + 30min transition) -->
  <static>
    <duration>9000</duration>
    <file>$WALLPAPER_DIR/6.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/6.png</from>
    <to>$WALLPAPER_DIR/7.png</to>
  </transition>

  <!-- 18h00 → 20h00 : Coucher de soleil (1h30 fixe + 30min transition) -->
  <static>
    <duration>5400</duration>
    <file>$WALLPAPER_DIR/7.png</file>
  </static>
  <transition type="overlay">
    <duration>1800</duration>
    <from>$WALLPAPER_DIR/7.png</from>
    <to>$WALLPAPER_DIR/8.png</to>
  </transition>

  <!-- 20h00 → 00h00 : Crépuscule + aurore (3h30 fixe + 30min transition) -->
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

  success "XML dynamique généré → $DYNAMIC_XML"
}

# ── Enregistrement dans GNOME ─────────────────────────────────────────────────
register_gnome() {
  step "Enregistrement dans GNOME"

  mkdir -p "$GNOME_PROPS_DIR"

  cat > "$GNOME_XML" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<wallpapers>
  <wallpaper deleted="false">
    <name>Islande dynamique</name>
    <filename>$DYNAMIC_XML</filename>
    <options>zoom</options>
    <pcolor>#000000</pcolor>
    <scolor>#000000</scolor>
  </wallpaper>
</wallpapers>
EOF

  success "Wallpaper enregistré dans GNOME → $GNOME_XML"
}

# ── Application immédiate ─────────────────────────────────────────────────────
apply_wallpaper() {
  step "Application du wallpaper"

  gsettings set org.gnome.desktop.background picture-uri \
    "file://$DYNAMIC_XML"
  gsettings set org.gnome.desktop.background picture-uri-dark \
    "file://$DYNAMIC_XML"
  gsettings set org.gnome.desktop.background picture-options "zoom"

  success "Wallpaper appliqué !"
}

# ── Désinstallation ───────────────────────────────────────────────────────────
uninstall() {
  step "Désinstallation"
  rm -rf "$WALLPAPER_DIR" "$GNOME_XML"
  gsettings reset org.gnome.desktop.background picture-uri
  gsettings reset org.gnome.desktop.background picture-uri-dark
  success "Wallpaper supprimé"
  exit 0
}

# ── Résumé ────────────────────────────────────────────────────────────────────
print_summary() {
  echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD}  ✔  Islande Dynamic Wallpaper installé !${RESET}"
  echo -e "${GREEN}${BOLD}══════════════════════════════════════════${RESET}"
  echo -e "  Le fond d'écran changera automatiquement"
  echo -e "  selon l'heure de la journée.\n"
  echo -e "  Tu peux aussi le sélectionner manuellement"
  echo -e "  dans ${BOLD}Paramètres → Arrière-plan${RESET}\n"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  echo -e "\n${BOLD}Islande Dynamic Wallpaper — Setup${RESET}"
  echo -e "Paysage islandais animé pour GNOME\n"

  [[ "${1:-}" == "--uninstall" ]] && uninstall

  check_dependencies
  install_wallpapers
  generate_dynamic_xml
  register_gnome
  apply_wallpaper
  print_summary
}

main "$@"
