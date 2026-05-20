#!/bin/bash

INBOX="$HOME/inbox"

if [[ ! -d "$INBOX" ]]; then
    echo "Inbox not found. Creating $INBOX..."
    mkdir -p "$INBOX"
    exit 0
fi

# Check if inbox has files
if [ -z "$(ls -A "$INBOX")" ]; then
    echo "Inbox is empty. Put some music in $INBOX and try again."
    exit 0
fi

# 1. Snapshot the library before import
echo "Taking snapshot of current library..."
# Sort is required for the 'comm' command later
OLD_IDS=$(beet ls -a -f '$id' | sort -n)

echo -e "\n\e[1;34mStep 1: Importing inbox...\e[0m"
# -m: moves audio files to library
# -g: (group-albums) ignores folders and groups tracks by metadata
beet import -m -g "$INBOX"

# 2. Snapshot the library after import and find the difference
ALL_IDS=$(beet ls -a -f '$id' | sort -n)
# comm -13 outputs lines that only exist in the second file (ALL_IDS)
NEW_ALBUMS=$(comm -13 <(echo "$OLD_IDS") <(echo "$ALL_IDS"))

if [[ -z "$NEW_ALBUMS" ]]; then
    echo -e "\n\e[1;33mNo new albums were added to the library.\e[0m"
else
    echo -e "\n\e[1;34mStep 2: Fixing custom metadata for new albums...\e[0m"
    for aid in $NEW_ALBUMS; do
        ALBUM_NAME=$(beet ls -a -f '$albumartist - $album' "album_id:$aid")
        echo -e "\n\e[1;32mProcessing New Album:\e[0m \e[1;37m$ALBUM_NAME\e[0m (ID: $aid)"
        
        # Beets already fixed the year/artists/tracks during import.
        # Now we enforce the custom genre rule.
        echo "Enter genres separated by semicolons (e.g., 'Rock; Alternative; Indie')."
        read -p "Genres: " new_genres
        
        if [[ -n "$new_genres" ]]; then
            beet modify -y "album_id:$aid" genre="$new_genres"
            echo "Genres updated."
        else
            echo "No genres entered, skipping."
        fi
        
        # Ensure cover art was fetched
        beet fetchart "album_id:$aid"
    done
fi

# 3. Clean up the inbox
echo -e "\n\e[1;34mStep 3: Cleaning up the inbox...\e[0m"
echo "Removing leftover non-music files (logs, nfo, images) from $INBOX..."
# This deletes everything remaining in the inbox
rm -rf "${INBOX:?}"/*
echo -e "\e[1;32mInbox completely cleared.\e[0m"

echo -e "\nWorkflow complete."
