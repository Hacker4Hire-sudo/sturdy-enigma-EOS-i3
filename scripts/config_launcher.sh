#!/bin/bash
# ~/scripts/config_launcher.sh
# A comprehensive launcher to view and edit system configs and scripts.
# Optimized for speed using fast arrays and find commands.

# --- 1. DEFINE CORE CONFIGS ---
declare -A configs=(
    ["Bashrc"]="$HOME/.bashrc"
    ["Profile"]="$HOME/.profile"
    ["i3 Config"]="$HOME/.config/i3/config"
    ["i3 Blocks"]="$HOME/.config/i3/i3blocks.conf"
    ["Picom Config"]="$HOME/.config/picom/picom.conf"
    ["Rofi Powermenu"]="$HOME/.config/rofi/powermenu.rasi"
    ["Rofi Keyhint"]="$HOME/.config/rofi/rofikeyhint.rasi"
)

# --- 2. GATHER SCRIPTS DYNAMICALLY ---
# Using mapfile and find to quickly grab scripts across directories
mapfile -t ai_scripts < <(find "$HOME/AI" -type f -name "*.sh" 2>/dev/null)
mapfile -t local_bin_scripts < <(find "$HOME/.local/bin" -type f -executable 2>/dev/null)
mapfile -t user_scripts < <(find "$HOME/scripts" -type f ! -name "config_launcher.sh" 2>/dev/null)

# --- 3. BUILD THE ROFI MENU ---
menu_content="--- [ CORE CONFIGURATIONS ] ---\n"
for label in "${!configs[@]}"; do
    menu_content+="${label}\n"
done

menu_content+="\n--- [ AI SCRIPTS ] ---\n"
for script in "${ai_scripts[@]}"; do
    menu_content+="$(basename "$script")|AI\n"
done

menu_content+="\n--- [ LOCAL BIN SCRIPTS ] ---\n"
for script in "${local_bin_scripts[@]}"; do
    menu_content+="$(basename "$script")|BIN\n"
done

menu_content+="\n--- [ USER SCRIPTS ] ---\n"
for script in "${user_scripts[@]}"; do
    menu_content+="$(basename "$script")|USER\n"
done

# --- 4. DISPLAY ROFI ---
# We use echo -e to interpret newlines and pass to rofi
selected=$(echo -e "$menu_content" | awk 'NF' | rofi -dmenu -i -p "Edit File (Geany):" -l 20)

# --- 5. LOGIC TO OPEN ---
if [[ -z "$selected" || "$selected" == ---* ]]; then
    exit 0
fi

# Check if selected is a core config
if [[ -n "${configs[$selected]}" ]]; then
    geany "${configs[$selected]}" &
    exit 0
fi

# If it's a script, parse out the tag
filename=$(echo "$selected" | cut -d'|' -f1)
category=$(echo "$selected" | cut -d'|' -f2)

case "$category" in
    "AI")
        geany "$HOME/AI/$filename" & ;;
    "BIN")
        geany "$HOME/.local/bin/$filename" & ;;
    "USER")
        geany "$HOME/scripts/$filename" & ;;
    *)
        # Fallback if somehow just a name was passed
        target=$(find "$HOME/AI" "$HOME/.local/bin" "$HOME/scripts" -name "$filename" -type f | head -n 1)
        if [[ -n "$target" ]]; then
            geany "$target" &
        fi
        ;;
esac
