# --- Hacking-Station Bible Logic ---
bible() {
    local BIBLE_DIR="${BIBLE_PATH:-$HOME/Bible/Books}"
    local BOOK="$1"
    
    # Resolve book file
    if [ -f "$BIBLE_DIR/$BOOK.txt" ]; then
        BOOK="$BOOK.txt"
    elif [ -f "$BIBLE_DIR/$BOOK" ]; then
        :
    else
        BOOK=$(ls "$BIBLE_DIR"/ 2>/dev/null | grep -i "${1// /}" | head -n 1)
    fi

    if [ -z "$BOOK" ] || [ ! -f "$BIBLE_DIR/$BOOK" ]; then
        echo "Book not found in $BIBLE_DIR."
        return
    fi

    # Parse Reference (e.g., "3:16")
    local CHAPTER=$(echo "$2" | cut -d: -f1)
    local VERSE=$(echo "$2" | cut -d: -f2)

    # Extract text: Find CHAPTER, then find VERSE within it
    local VERSE_TEXT=$(awk -v c="CHAPTER $CHAPTER" -v v="^$VERSE " '
        $0 ~ c {f=1; next}
        f && $0 ~ /^CHAPTER/ {f=0; exit}
        f && $0 ~ v {sub("^[0-9]+ ", ""); print; exit}
    ' "$BIBLE_DIR/$BOOK" | tr -d '\r' | tr '\n' ' ' | sed 's/  */ /g')
    
    echo -e "\e[1;36m  $BOOK ($2)\e[0m"
    if [ -z "$VERSE_TEXT" ]; then
        echo "   Verse $2 not found in $BOOK."
    else
        echo -e "   $VERSE $VERSE_TEXT" | fmt -w 65 | sed 's/^/   /'
        [[ "$3" == "-s" ]] && ~/AI/speak.sh "$VERSE $VERSE_TEXT" &
    fi
}

biblesearch() {
    local BIBLE_DIR="${BIBLE_PATH:-$HOME/Bible/Books}"
    if [ -z "$1" ]; then echo "Usage: biblesearch keyword"; return; fi
    echo -e "\e[1;33mSearching for: \"$1\"...\e[0m"
    grep -ri "$1" "$BIBLE_DIR"/ | sed 's|.*/||; s/\.txt//' | awk -F: '{printf "\033[1;36m%s\033[0m \033[1;33m%s\033[0m: %s\n", $1, $2, $3}' | fmt -w 80 -t | head -n 25
}

alias grace='biblesearch "grace"'
alias faith='biblesearch "faith"'
alias repent='biblesearch "repent"'
