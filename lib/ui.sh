#!/usr/bin/env bash
# Setup UI: step plan on stdout, full command output in a log file.

if [[ -n "${SETUP_UI_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
SETUP_UI_LOADED=1

SETUP_UI_LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/setup"
SETUP_UI_LOG_FILE=""
SETUP_UI_INTERACTIVE=0
SETUP_UI_IN_ALT=0
SETUP_UI_SUDO_KEEPALIVE_PID=""

declare -a SETUP_UI_LABELS=()
declare -a SETUP_UI_STATUS=()
declare -a SETUP_UI_TTY_STEP=()
declare -a SETUP_UI_SLOW_STEP=()
declare -a SETUP_UI_SLOW_HINT=()

SETUP_UI_SLOW_IDX=""
SETUP_UI_SLOW_START=0
SETUP_UI_SLOW_TIMER_SAVED=0

setup_ui__status_icon() {
  case "$1" in
    pending) printf '[ ]' ;;
    running) printf '[…]' ;;
    done)    printf '[✓]' ;;
    error)   printf '[✗]' ;;
    skipped) printf '[−]' ;;
    *)       printf '[ ]' ;;
  esac
}

setup_ui__status_color_on() {
  case "$1" in
    pending) printf '\033[2m' ;;
    running) printf '\033[1;36m' ;;
    done)    printf '\033[1;32m' ;;
    error)   printf '\033[1;31m' ;;
    skipped) printf '\033[2;33m' ;;
    *)       printf '\033[0m' ;;
  esac
}

setup_ui__status_color_off() {
  printf '\033[0m'
}

setup_ui__cleanup() {
  if [[ -n "${SETUP_UI_SUDO_KEEPALIVE_PID:-}" ]]; then
    kill "$SETUP_UI_SUDO_KEEPALIVE_PID" 2>/dev/null || true
    SETUP_UI_SUDO_KEEPALIVE_PID=""
  fi

  if (( SETUP_UI_IN_ALT )); then
    tput rmcup 2>/dev/null || true
    SETUP_UI_IN_ALT=0
  fi

  tput cnorm 2>/dev/null || true
}

setup_ui_init() {
  mkdir -p "$SETUP_UI_LOG_DIR"
  SETUP_UI_LOG_FILE="$SETUP_UI_LOG_DIR/setup-$(date +%Y%m%d-%H%M%S).log"
  ln -sfn "$SETUP_UI_LOG_FILE" "$SETUP_UI_LOG_DIR/latest.log"

  if [[ -t 1 ]]; then
    SETUP_UI_INTERACTIVE=1
  fi

  trap setup_ui__cleanup EXIT

  {
    printf '=== setup log ===\n'
    printf 'started: %s\n' "$(date -Iseconds)"
    printf 'host:    %s\n' "$(hostname 2>/dev/null || echo unknown)"
    printf 'user:    %s\n' "$(id -un 2>/dev/null || echo unknown)"
    printf 'log:     %s\n' "$SETUP_UI_LOG_FILE"
    printf '=================\n\n'
  } >>"$SETUP_UI_LOG_FILE"
}

setup_ui__format_elapsed() {
  local seconds="$1"
  local mins=$((seconds / 60))
  local secs=$((seconds % 60))
  printf '%dm %02ds' "$mins" "$secs"
}

setup_ui_register() {
  local tty=0 slow=0
  local slow_hint="builds from source, several minutes"

  while [[ "${1:-}" == --* ]]; do
    case "$1" in
      --tty)
        tty=1
        shift
        ;;
      --slow)
        slow=1
        shift
        if [[ -n "${1:-}" && "${1:-}" != --* ]]; then
          slow_hint="$1"
          shift
        fi
        ;;
      *)
        break
        ;;
    esac
  done

  local label="$1"
  shift
  local idx=${#SETUP_UI_LABELS[@]}

  SETUP_UI_LABELS+=("$label")
  SETUP_UI_STATUS+=("pending")
  SETUP_UI_TTY_STEP+=("$tty")
  SETUP_UI_SLOW_STEP+=("$slow")
  SETUP_UI_SLOW_HINT+=("$slow_hint")
  eval "SETUP_UI_CMD_${idx}=($(printf '%q ' "$@"))"
}

setup_ui_register_dir() {
  local prefix="$1"
  local dir="$2"
  local use_sudo="${3:-}"

  if [[ ! -d "$dir" ]]; then
    return 0
  fi

  local script
  while IFS= read -r script; do
    local name
    name="$(basename "$script" .sh)"
    if [[ "$name" == "apply" ]]; then
      name="$(basename "$(dirname "$script")")"
    fi

    if [[ -n "$use_sudo" ]]; then
      setup_ui_register "$prefix · $name" sudo "$script"
    else
      setup_ui_register "$prefix · $name" "$script"
    fi
  done < <(find "$dir" -maxdepth 1 -type f -name '*.sh' | sort)
}

setup_ui__needs_sudo() {
  local i
  for i in "${!SETUP_UI_LABELS[@]}"; do
    local -a cmd=()
    eval "cmd=(\"\${SETUP_UI_CMD_${i}[@]}\")"
    if [[ "${cmd[0]:-}" == "sudo" ]]; then
      return 0
    fi
  done
  return 1
}

setup_ui__ensure_sudo() {
  if ! setup_ui__needs_sudo; then
    return 0
  fi

  export SUDO_PROMPT='Password for user %p needed: '
  sudo -v

  (
    while true; do
      sleep 60
      sudo -n true 2>/dev/null || exit
    done
  ) &
  SETUP_UI_SUDO_KEEPALIVE_PID=$!
}

setup_ui__enter_dashboard() {
  if (( ! SETUP_UI_INTERACTIVE )); then
    return 0
  fi

  if (( ! SETUP_UI_IN_ALT )); then
    tput smcup 2>/dev/null || SETUP_UI_INTERACTIVE=0
  fi

  if (( SETUP_UI_INTERACTIVE )); then
    SETUP_UI_IN_ALT=1
    tput civis 2>/dev/null || true
  fi
}

setup_ui__leave_dashboard() {
  if (( SETUP_UI_INTERACTIVE && SETUP_UI_IN_ALT )); then
    tput rmcup 2>/dev/null || true
    SETUP_UI_IN_ALT=0
  fi

  if (( SETUP_UI_INTERACTIVE )); then
    tput cnorm 2>/dev/null || true
  fi
}

setup_ui__draw_dashboard() {
  local log_display="${SETUP_UI_LOG_DIR}/latest.log"
  local i

  if (( SETUP_UI_INTERACTIVE && SETUP_UI_IN_ALT )); then
    tput clear 2>/dev/null || true
    printf '\033[1mSetup\033[0m\n'
    printf 'Full output → %s\n\n' "$log_display"
  elif (( SETUP_UI_INTERACTIVE )); then
    printf '\033[1mSetup\033[0m\n'
    printf 'Full output → %s\n\n' "$log_display"
  else
    printf 'Setup (log → %s)\n\n' "$log_display"
  fi

  for i in "${!SETUP_UI_LABELS[@]}"; do
    setup_ui__print_step "$i"
  done

  printf '\n'
}

setup_ui__print_step() {
  local i="$1"
  local label="${SETUP_UI_LABELS[$i]}"
  local status="${SETUP_UI_STATUS[$i]}"
  local icon suffix="" elapsed=""
  icon="$(setup_ui__status_icon "$status")"

  if (( SETUP_UI_SLOW_STEP[i] )) && [[ "$status" == "pending" || "$status" == "running" ]]; then
    suffix=" · ${SETUP_UI_SLOW_HINT[$i]}"
    if [[ "$status" == "running" && "$SETUP_UI_SLOW_IDX" == "$i" && "$SETUP_UI_SLOW_START" -gt 0 ]]; then
      elapsed=" · $(setup_ui__format_elapsed "$(( $(date +%s) - SETUP_UI_SLOW_START ))")"
    fi
  fi

  if (( SETUP_UI_INTERACTIVE && SETUP_UI_IN_ALT )); then
    setup_ui__status_color_on "$status"
    printf '\033[2K  %s  %s' "$icon" "$label"
    setup_ui__status_color_off
    if [[ -n "$suffix$elapsed" ]]; then
      if [[ "$status" == "running" && "$SETUP_UI_SLOW_IDX" == "$i" && -n "$elapsed" ]]; then
        printf '\033[2m%s' "$suffix"
        printf '\033[s'
        printf '%s\033[0m' "$elapsed"
        SETUP_UI_SLOW_TIMER_SAVED=1
      else
        printf '\033[2m%s%s\033[0m' "$suffix" "$elapsed"
      fi
    fi
    printf '\n'
  elif (( SETUP_UI_INTERACTIVE )); then
    setup_ui__status_color_on "$status"
    printf '  %s  %s' "$icon" "$label"
    setup_ui__status_color_off
    if [[ -n "$suffix$elapsed" ]]; then
      printf '\033[2m%s%s\033[0m' "$suffix" "$elapsed"
    fi
    printf '\n'
  else
    printf '  %s  %s' "$icon" "$label"
    if [[ -n "$suffix$elapsed" ]]; then
      printf '%s%s' "$suffix" "$elapsed"
    fi
    printf '\n'
  fi
}

setup_ui__refresh_slow_timer() {
  local idx="${SETUP_UI_SLOW_IDX:-}"
  local elapsed=""

  [[ -z "$idx" ]] && return 0
  (( SETUP_UI_INTERACTIVE && SETUP_UI_IN_ALT && SETUP_UI_SLOW_TIMER_SAVED )) || return 0
  (( SETUP_UI_SLOW_START > 0 )) || return 0

  elapsed=" · $(setup_ui__format_elapsed "$(( $(date +%s) - SETUP_UI_SLOW_START ))")"
  printf '\033[u\033[2m%s\033[0m\033[K' "$elapsed"
}

setup_ui__set_status() {
  local idx="$1"
  local status="$2"

  SETUP_UI_STATUS[$idx]="$status"

  if (( SETUP_UI_INTERACTIVE && SETUP_UI_IN_ALT )); then
    setup_ui__draw_dashboard
  else
    setup_ui__print_step "$idx"
  fi
}

setup_ui_show_plan() {
  setup_ui__draw_dashboard
}

setup_ui__run_command() {
  local idx="$1"
  local label="${SETUP_UI_LABELS[$idx]}"
  local -a cmd=()
  local exit_code=0

  eval "cmd=(\"\${SETUP_UI_CMD_${idx}[@]}\")"

  {
    printf '======== %s STEP: %s ========\n' "$(date -Iseconds)" "$label"
    printf 'command:'
    printf ' %q' "${cmd[@]}"
    printf '\n\n'
  } >>"$SETUP_UI_LOG_FILE"

  set +e
  "${cmd[@]}" >>"$SETUP_UI_LOG_FILE" 2>&1
  exit_code=$?
  set -e

  {
    printf '\n======== END STEP (exit %s) ========\n\n' "$exit_code"
  } >>"$SETUP_UI_LOG_FILE"

  return "$exit_code"
}

setup_ui__run_interactive_command() {
  local idx="$1"
  local label="${SETUP_UI_LABELS[$idx]}"
  local -a cmd=()
  local exit_code=0

  eval "cmd=(\"\${SETUP_UI_CMD_${idx}[@]}\")"

  {
    printf '======== %s STEP (interactive): %s ========\n' "$(date -Iseconds)" "$label"
    printf 'command:'
    printf ' %q' "${cmd[@]}"
    printf '\n(prompt and output on terminal, not captured below)\n\n'
  } >>"$SETUP_UI_LOG_FILE"

  set +e
  "${cmd[@]}"
  exit_code=$?
  set -e

  {
    printf '======== END STEP (exit %s) ========\n\n' "$exit_code"
  } >>"$SETUP_UI_LOG_FILE"

  return "$exit_code"
}

setup_ui__run_command_with_timer() {
  local idx="$1"
  local cmd_pid=0
  local exit_code=0

  setup_ui__run_command "$idx" &
  cmd_pid=$!

  while kill -0 "$cmd_pid" 2>/dev/null; do
    sleep 1
    setup_ui__refresh_slow_timer
  done

  wait "$cmd_pid"
  exit_code=$?
  return "$exit_code"
}

setup_ui__run_index() {
  local idx="$1"
  local label="${SETUP_UI_LABELS[$idx]}"
  local -a cmd=()
  local exit_code=0
  local tty_step="${SETUP_UI_TTY_STEP[$idx]:-0}"

  eval "cmd=(\"\${SETUP_UI_CMD_${idx}[@]}\")"

  if [[ ! -x "${cmd[-1]}" && "${cmd[-1]}" == *.sh ]]; then
    {
      printf '======== %s SKIP (not executable): %s ========\n' "$(date -Iseconds)" "$label"
      printf 'script: %s\n' "${cmd[-1]}"
      printf '======== END SKIP ========\n\n'
    } >>"$SETUP_UI_LOG_FILE"

    setup_ui__set_status "$idx" "skipped"
    return 0
  fi

  if (( tty_step )); then
    setup_ui__leave_dashboard
    printf '\n\033[1m%s\033[0m\n\n' "$label"

    SETUP_UI_STATUS[$idx]="running"

    if setup_ui__run_interactive_command "$idx"; then
      SETUP_UI_STATUS[$idx]="done"
    else
      exit_code=$?
      SETUP_UI_STATUS[$idx]="error"
      setup_ui__enter_dashboard
      setup_ui_show_plan
      return "$exit_code"
    fi

    setup_ui__enter_dashboard
    setup_ui_show_plan
    return 0
  fi

  SETUP_UI_STATUS[$idx]="running"
  if (( SETUP_UI_SLOW_STEP[idx] )); then
    SETUP_UI_SLOW_IDX=$idx
    SETUP_UI_SLOW_START=$(date +%s)
  fi
  setup_ui__draw_dashboard

  if (( SETUP_UI_SLOW_STEP[idx] )); then
    if setup_ui__run_command_with_timer "$idx"; then
      SETUP_UI_STATUS[$idx]="done"
    else
      exit_code=$?
      SETUP_UI_STATUS[$idx]="error"
      SETUP_UI_SLOW_IDX=""
      SETUP_UI_SLOW_START=0
      SETUP_UI_SLOW_TIMER_SAVED=0
      setup_ui__draw_dashboard
      return "$exit_code"
    fi
    SETUP_UI_SLOW_IDX=""
    SETUP_UI_SLOW_START=0
    SETUP_UI_SLOW_TIMER_SAVED=0
  elif setup_ui__run_command "$idx"; then
    SETUP_UI_STATUS[$idx]="done"
  else
    exit_code=$?
    SETUP_UI_STATUS[$idx]="error"
    setup_ui__draw_dashboard
    return "$exit_code"
  fi

  # apt/sudo write progress to /dev/tty, so always full redraw after a step.
  setup_ui__draw_dashboard
  return 0
}

setup_ui__finish_success() {
  setup_ui__leave_dashboard

  if (( SETUP_UI_INTERACTIVE )); then
    printf '\n'
    setup_ui_show_plan
    printf '\033[1;32mSetup completed\033[0m · %s step(s)\n' "${#SETUP_UI_LABELS[@]}"
  else
    printf '\nSetup completed · %s step(s)\n' "${#SETUP_UI_LABELS[@]}"
    setup_ui_show_plan
  fi
}

setup_ui_run_all() {
  setup_ui__ensure_sudo
  setup_ui__enter_dashboard
  setup_ui_show_plan

  local i
  for i in "${!SETUP_UI_LABELS[@]}"; do
    if ! setup_ui__run_index "$i"; then
      setup_ui__leave_dashboard
      printf '\n\033[1;31mSetup failed\033[0m at step %s\n' "$((i + 1))"
      printf 'See log → %s\n' "${SETUP_UI_LOG_DIR}/latest.log"
      return 1
    fi
  done

  setup_ui__finish_success
}
