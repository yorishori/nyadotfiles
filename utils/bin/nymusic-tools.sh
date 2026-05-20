#!/bin/bash

# Ensure beets is installed
if ! command -v beet &> /dev/null; then
    echo "Error: 'beet' command not found. Please install beets."
    exit 1
fi

# Define paths matching your beets config
DB_PATH="$HOME/.local/share/beets/library.db"
LIBRARY_DIR="/mnt/server-nya/music/library"

# Function to run your interactive library fix workflow
run_fix() {
    echo "Scanning library for metadata issues..."
    echo "--------------------------------------------------------"

    # Get all album IDs in the library
    ALBUM_IDS=$(beet ls -a -f '$id')

    for aid in $ALBUM_IDS; do
        NEEDS_FIX=0
        REASON=""

        # 1. Check for missing cover art
        ARTPATH=$(beet ls -a -f '$artpath' "album_id:$aid")
        if [[ -z "$ARTPATH" ]]; then
            NEEDS_FIX=1
            REASON+="Missing cover art. "
        fi

        # Retrieve track data using '^' as a delimiter to avoid conflicts with track names
        TRACK_DATA=$(beet ls -f '$id^$title^$track^$disc^$year^$artist^$album^$albumartist^$composer^$genres' "album_id:$aid")

        # Arrays to track consistency across the album
        unset ARTISTS ALBUMARTISTS GENRES
        declare -A ARTISTS ALBUMARTISTS GENRES

        # Read each track's metadata
        while IFS='^' read -r tid title track disc year artist album albumartist composer genres; do
            
            # 2. Check for missing fields
            if [[ -z "$title" || -z "$track" || -z "$disc" || -z "$year" || -z "$artist" || -z "$album" || -z "$albumartist" || -z "$composer" || -z "$genres" ]]; then
                NEEDS_FIX=1
                REASON+="Missing fields in track $tid. "
            fi

            # 3. Check if year is a full date instead of just 4 digits
            if ! [[ "$year" =~ ^[0-9]{4}$ ]]; then
                NEEDS_FIX=1
                REASON+="Year format is incorrect ($year). "
            fi

            # 4. Check for single genre (no semicolon present)
            if [[ "$genres" != *";"* ]]; then
                NEEDS_FIX=1
                REASON+="Only one genre or missing delimiters ($genres). "
            fi

            # Populate dictionaries to check for consistency
            [[ -n "$artist" ]] && ARTISTS["$artist"]=1
            [[ -n "$albumartist" ]] && ALBUMARTISTS["$albumartist"]=1
            [[ -n "$genres" ]] && GENRES["$genres"]=1

        done <<< "$TRACK_DATA"

        # 5. Check consistency rules
        if [[ ${#ARTISTS[@]} -gt 1 ]]; then NEEDS_FIX=1; REASON+="Inconsistent track artists. "; fi
        if [[ ${#ALBUMARTISTS[@]} -gt 1 ]]; then NEEDS_FIX=1; REASON+="Inconsistent album artists. "; fi
        if [[ ${#GENRES[@]} -gt 1 ]]; then NEEDS_FIX=1; REASON+="Inconsistent genres. "; fi

        # --- INTERACTIVE FIX PROMPT ---
        if [[ $NEEDS_FIX -eq 1 ]]; then
            ALBUM_NAME=$(beet ls -a -f '$albumartist - $album' "album_id:$aid")
            echo -e "\n\e[1;31mFlagged Album:\e[0m \e[1;37m$ALBUM_NAME\e[0m (ID: $aid)"
            echo -e "\e[1;33mIssues:\e[0m $REASON"
            
            read -p "Do you want to fix this album now? (y/N): " choice
            if [[ "$choice" =~ ^[Yy]$ ]]; then
                
                echo -e "\n\e[1;34mStep 1: Auto-filling metadata from MusicBrainz...\e[0m"
                beet import -L "album_id:$aid"

                echo -e "\n\e[1;34mStep 2: Fetching missing cover art...\e[0m"
                beet fetchart "album_id:$aid"

                echo -e "\n\e[1;34mStep 3: Setting Genres\e[0m"
                echo "Enter genres separated by semicolons (e.g., 'Rock; Alternative; Indie')."
                read -p "Genres: " new_genres
                
                if [[ -n "$new_genres" ]]; then
                    beet modify -y "album_id:$aid" genres="$new_genres"
                    echo "Genres updated."
                else
                    echo "No genres entered, skipping genre update."
                fi
                echo "--------------------------------------------------------"
            else
                echo "Skipping album..."
                echo "--------------------------------------------------------"
            fi
        fi
    done
    echo "Library scan complete."
}

# --- PARAMETER CHECKER ---
case "$1" in
    "update")
        echo -e "\e[1;34mRunning beets update...\e[0m"
        beet update
        ;;
        
    "rebuild")
        echo -e "\e[1;31m⚠️  WARNING: You are about to delete your beets database file ($DB_PATH) and rebuild it from files.\e[0m"
        read -p "Are you sure you want to proceed? (y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            if [[ -f "$DB_PATH" ]]; then
                echo "Removing database file..."
                rm "$DB_PATH"
            fi
            echo -e "\n\e[1;34mRebuilding database from library files (trusting local tags)...\e[0m"
            beet import -AWC "$LIBRARY_DIR"
            echo -e "\e[1;32mDatabase completely rebuilt.\e[0m"
        else
            echo "Rebuild aborted."
        fi
        ;;
        
    "fix")
        run_fix
        ;;
        
    *)
        echo "Usage: $0 {update|rebuild|fix}"
        exit 1
        ;;
esac
