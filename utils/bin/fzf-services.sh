#!/bin/bash

export SYSTEMD_COLORS=0

# ── Catppuccin Mocha palette ────────────────────────────────────────
RED='\033[38;2;243;139;168m'      # #f38ba8
GREEN='\033[38;2;166;227;161m'    # #a6e3a1
YELLOW='\033[38;2;249;226;175m'   # #f9e2af
LAVENDER='\033[38;2;180;190;254m' # #b4befe  (system)
MAUVE='\033[38;2;203;166;247m'    # #cba6f7  (user)
SUBTEXT='\033[38;2;166;173;200m'  # #a6adc8
OVERLAY='\033[38;2;108;112;134m'  # #6c7086
SURFACE='\033[38;2;88;91;112m'    # #585b70
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ── Reload helper (used in --bind actions) ───────────────────────────
RELOAD_CMD='{ systemctl list-unit-files --no-legend --no-pager 2>/dev/null | awk "{print \$1,\$2,\$3,\"system\"}"; systemctl --user list-unit-files --no-legend --no-pager 2>/dev/null | awk "{print \$1,\$2,\$3,\"user\"}"; } | sort -u'

# ── Build unit list with fixed-width columns ─────────────────────────
ALL_UNITS=$(
  {
    systemctl list-unit-files --no-legend --no-pager 2>/dev/null \
      | awk '{print $1, $2, "system"}'
    systemctl --user list-unit-files --no-legend --no-pager 2>/dev/null \
      | awk '{print $1, $2, "user"}'
  } | sort -u | awk '
    BEGIN { OFS="" }
    {
      unit   = $1
      state  = $2
      scope  = $3

      # color for enabled state
      if (state == "enabled")        sc = "\033[38;2;166;227;161m"  # green
      else if (state == "disabled")  sc = "\033[38;2;243;139;168m"  # red
      else                           sc = "\033[38;2;108;112;134m"  # overlay (dim)

      # color for scope
      if (scope == "system") pc = "\033[38;2;180;190;254m"          # lavender
      else                   pc = "\033[38;2;203;166;247m"           # mauve

      reset = "\033[0m"

      printf "%-45s  %s%-10s%s  %s%-6s%s\n",
        unit,
        sc, state, reset,
        pc, scope, reset
    }
  '
)

echo "$ALL_UNITS" \
| fzf \
    --ansi \
    --layout=reverse \
    --border=rounded \
    --prompt="$(printf '\033[38;2;203;166;247m') search › $(printf '\033[0m')" \
    --pointer="" \
    --color='bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,hl:#cba6f7,hl+:#cba6f7,border:#585b70,prompt:#cba6f7,pointer:#f5c2e7,header:#6c7086,info:#6c7086' \
    --preview-window=right:48%:wrap:border-left \
    --preview='
      unit=$(echo {} | awk "{print \$1}")
      scope=$(echo {} | awk "{print \$3}")
      user_flag=""
      [ "$scope" = "user" ] && user_flag="--user"

      active=$(systemctl $user_flag is-active "$unit" 2>/dev/null)
      enabled=$(systemctl $user_flag is-enabled "$unit" 2>/dev/null)

      case "$active" in
        active)   ac="\033[38;2;166;227;161m" ;;
        inactive) ac="\033[38;2;249;226;175m" ;;
        failed)   ac="\033[38;2;243;139;168m" ;;
        *)        ac="\033[38;2;108;112;134m" ;;
      esac
      case "$enabled" in
        enabled)  ec="\033[38;2;166;227;161m" ;;
        disabled) ec="\033[38;2;243;139;168m" ;;
        *)        ec="\033[38;2;108;112;134m" ;;
      esac
      [ "$scope" = "system" ] && pc="\033[38;2;180;190;254m" || pc="\033[38;2;203;166;247m"

      RST="\033[0m"
      DIM="\033[2m"
      BLD="\033[1m"
      SEP="${DIM}────────────────────────────────────────${RST}"

      echo -e "${BLD}${pc}${unit}${RST}  ${DIM}[${scope}]${RST}"
      echo -e "$SEP"
      echo -e " ${DIM}Active: ${RST}${ac}${active}${RST}   ${DIM}Enabled: ${RST}${ec}${enabled}${RST}"
      echo ""

      systemctl $user_flag show "$unit" \
        --property=Description,Type,MainPID,ExecMainStartTimestamp,FragmentPath,\
LoadState,SubState,Restart,MemoryCurrent,User,WorkingDirectory \
        2>/dev/null \
      | grep -v "^$" \
      | awk -F= -v RST="\033[0m" -v DIM="\033[2m" -v BLD="\033[1m" "
        /^Description=/     { printf \" ${BLD}%-10s${RST} %s\n\", \"Desc:\",    \$2 }
        /^Type=/             { printf \" ${BLD}%-10s${RST} %s\n\", \"Type:\",    \$2 }
        /^LoadState=/        { printf \" ${BLD}%-10s${RST} %s\n\", \"Load:\",    \$2 }
        /^SubState=/         { printf \" ${BLD}%-10s${RST} %s\n\", \"Sub:\",     \$2 }
        /^MainPID=/          { if (\$2 != \"0\") printf \" ${BLD}%-10s${RST} %s\n\", \"PID:\",     \$2 }
        /^ExecMainStart/     { if (\$2 != \"\")  printf \" ${BLD}%-10s${RST} %s\n\", \"Started:\", \$2 }
        /^Restart=/          { printf \" ${BLD}%-10s${RST} %s\n\", \"Restart:\", \$2 }
        /^User=/             { if (\$2 != \"\")  printf \" ${BLD}%-10s${RST} %s\n\", \"User:\",    \$2 }
        /^WorkingDirectory=/ { if (\$2 != \"\")  printf \" ${BLD}%-10s${RST} %s\n\", \"CWD:\",     \$2 }
        /^FragmentPath=/     { if (\$2 != \"\")  printf \" ${BLD}%-10s${RST} %s\n\", \"File:\",    \$2 }
        /^MemoryCurrent=/    { if (\$2 != \"[not set]\" && \$2 != \"18446744073709551615\") printf \" ${BLD}%-10s${RST} %s B\n\", \"Memory:\", \$2 }
      "

      echo ""
      echo -e "${DIM}── Shortcuts ───────────────────────────${RST}"
      echo -e " ${pc}ENTER${RST}        full status (pager)"
      echo -e " ${pc}CTRL-L${RST}       live log tail (journalctl -f)"
      echo -e " ${pc}CTRL-J${RST}       recent logs (last 50 lines)"
      echo -e " ${pc}CTRL-S${RST}       start unit"
      echo -e " ${pc}CTRL-T${RST}       stop unit"
      echo -e " ${pc}CTRL-R${RST}       restart unit"
      echo -e " ${pc}CTRL-E${RST}       enable unit"
      echo -e " ${pc}CTRL-D${RST}       disable unit"
      echo -e " ${pc}CTRL-Q/ESC${RST}   quit"
    ' \
    --bind 'enter:execute(
      unit=$(echo {} | awk "{print \$1}")
      scope=$(echo {} | awk "{print \$4}")
      flag=""; [ "$scope" = "user" ] && flag="--user"
      systemctl $flag status "$unit" --no-pager | less > /dev/tty 2>&1
    )' \
    --bind 'ctrl-l:execute(
      unit=$(echo {} | awk "{print \$1}")
      scope=$(echo {} | awk "{print \$4}")
      flag=""; [ "$scope" = "user" ] && flag="--user"
      journalctl $flag -u "$unit" -f --no-pager > /dev/tty 2>&1
    )' \
    --bind 'ctrl-j:execute(
      unit=$(echo {} | awk "{print \$1}")
      scope=$(echo {} | awk "{print \$4}")
      flag=""; [ "$scope" = "user" ] && flag="--user"
      journalctl $flag -u "$unit" -n 50 --no-pager | less > /dev/tty 2>&1
    )' \
    --bind "ctrl-s:execute(
      unit=\$(echo {} | awk '{print \$1}')
      scope=\$(echo {} | awk '{print \$4}')
      flag=\"\"; [ \"\$scope\" = \"user\" ] && flag=\"--user\"
      systemctl \$flag start \"\$unit\" > /dev/tty 2>&1
    )+reload($RELOAD_CMD)" \
    --bind "ctrl-t:execute(
      unit=\$(echo {} | awk '{print \$1}')
      scope=\$(echo {} | awk '{print \$4}')
      flag=\"\"; [ \"\$scope\" = \"user\" ] && flag=\"--user\"
      systemctl \$flag stop \"\$unit\" > /dev/tty 2>&1
    )+reload($RELOAD_CMD)" \
    --bind "ctrl-r:execute(
      unit=\$(echo {} | awk '{print \$1}')
      scope=\$(echo {} | awk '{print \$4}')
      flag=\"\"; [ \"\$scope\" = \"user\" ] && flag=\"--user\"
      systemctl \$flag restart \"\$unit\" > /dev/tty 2>&1
    )+reload($RELOAD_CMD)" \
    --bind "ctrl-e:execute(
      unit=\$(echo {} | awk '{print \$1}')
      scope=\$(echo {} | awk '{print \$4}')
      flag=\"\"; [ \"\$scope\" = \"user\" ] && flag=\"--user\"
      systemctl \$flag enable \"\$unit\" > /dev/tty 2>&1
    )+reload($RELOAD_CMD)" \
    --bind "ctrl-d:execute(
      unit=\$(echo {} | awk '{print \$1}')
      scope=\$(echo {} | awk '{print \$4}')
      flag=\"\"; [ \"\$scope\" = \"user\" ] && flag=\"--user\"
      systemctl \$flag disable \"\$unit\" > /dev/tty 2>&1
    )+reload($RELOAD_CMD)"
