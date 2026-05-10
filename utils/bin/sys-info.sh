#!/bin/bash
# ──────────────────────────────
# Colors (FIXED)
# ──────────────────────────────
c=$'\e[38;2;203;166;247m'
l=$'\e[38;2;203;166;247m'
t=$'\e[38;2;205;214;244m'
h=$'\e[38;2;186;194;222m'
r=$'\e[0m'

# ──────────────────────────────
# Logo
# ──────────────────────────────
logo=(
""
" ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀"
" ⠀⠀⠀⠀⢀⡴⣆⠀⠀⠀⠀⠀⣠⡀⠀⠀⠀⠀⠀⠀⣼⣿⡗⠀⠀⠀⠀"
" ⠀⠀⠀⣠⠟⠀⠘⠷⠶⠶⠶⠾⠉⢳⡄⠀⠀⠀⠀⠀⣧⣿⠀⠀⠀⠀⠀"
"⠀ ⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣤⣤⣤⣤⣤⣿⢿⣄⠀⠀⠀⠀"
"⠀ ⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠙⣷⡴⠶⣦"
" ⠀⠀⢱⡀⠀⠉⠉⠀⠀⠀⠀⠛⠃⠀⢠⡟⠀⠀⠀⢀⣀⣠⣤⠿⠞⠛⠋"
" ⣠⠾⠋⠙⣶⣤⣤⣤⣤⣤⣀⣠⣤⣾⣿⠴⠶⠚⠋⠉⠁⠀⠀⠀⠀⠀⠀"
" ⠛⠒⠛⠉⠉⠀⠀⠀⣴⠟⢃⡴⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
" ⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
"   ⣀⡀ ⡀⢀ ⢀⣀ ⡀⣀ ⢀⣀ ⣇⡀  "
"   ⠇⠸ ⣑⡺ ⠣⠼ ⠏  ⠣⠤ ⠇⠸  "
)

# ──────────────────────────────
# System info
# ──────────────────────────────
cpu_name=$(lscpu | sed -n 's/^Model name:\s*//p')
cpu_cores=$(lscpu -p | grep -v "^#" | awk -F, '{print $2}' | sort -u | wc -l)
cpu_threads=$(lscpu -p | grep -v "^#" | wc -l)
gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null)
vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader | awk '{print $1/1024 " GB"}')
ram_total=$(awk '/MemTotal/ {printf "%.2f GB\n", $2/1024/1024}' /proc/meminfo)
kernel=$(uname -r)
h_version=$(hyprland --version | awk -F'[,:]' '/Tag:/ {gsub(/^ /, "", $2); print $2}')
n_version=$(pacman -Qi noctalia-shell 2>/dev/null | grep "Version" | awk '{print "v" $3}' | sed 's/-.*//')
mapfile -t displays < <(
    hyprctl monitors -j 2>/dev/null | jq -r '.[] | "[\(.name)] \(.width)x\(.height) \(.refreshRate|floor)Hz"'
)

info=(
    "$c $r $h$cpu_name$r"
    "|---$c $r $t$cpu_cores cores$r"
    "|---$c $r $t$cpu_threads threads$r"
    "\---$c $r $t$ram_total RAM"
    ""
    "$c󰢮 $r $h$gpu_name$r"
    "\---$c $r $t$vram$r"
    ""
)
for d in "${displays[@]}"; do
    info+=("$c󰍹 $r $t$d$r")
done
info+=(
    ""
    "$c $r Linux v$kernel "
    "$c󰣆 $r Hyprland $h_version "
    "$c $r Noctalia $n_version "
    ""
)

# ──────────────────────────────
# Render screen
# ──────────────────────────────
render_frame() {
    clear 
    cols=$(tput cols)
    rows=$(tput lines)
    half=$((cols / 2))
    
    logo_lines=${#logo[@]}
    info_lines=${#info[@]}
    max_lines=$((logo_lines > info_lines ? logo_lines : info_lines))
    
    printf "\n"
    for ((i=0; i<max_lines; i++)); do
        left_line=""
        right_line=""
        
        if [ $i -lt $logo_lines ]; then
            left_line="${logo[$i]}"
        fi
        _
        if [ $i -lt $info_lines ]; then
            right_line="${info[$i]}"
        fi

        left_len=$(printf "%s" "$left_line" | wc -L)

        if [ $left_len -lt $half ]; then
            spaces=$((($half - left_len)/2))
            printf "%${spaces}s" ""
            printf "%s" "$l$left_line$r"
            printf "%${spaces}s" ""
        else
            printf "%s" "$left_line" 
        fi

        printf "%s\n" "$right_line"
    done

    printf "\n"
    printf "\nPress any key to close...\n"
    # ──────────────────────────────
    # Wait for user input
    # ──────────────────────────────
    read -n1 -s -r -p ""
}

ghostty --size "160x25" -e bash render_frame

