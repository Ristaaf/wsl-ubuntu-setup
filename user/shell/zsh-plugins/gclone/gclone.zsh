source "${${(%):-%x}:A:h}/repos.zsh"

gclone() {
  emulate -L zsh
  local fresh=0
  while (( $# )) && [[ $1 == -* ]]; do
    case $1 in
      -f | --fresh) fresh=1; shift ;;
      -l | --list)  _gclone_list; return 0 ;;
      -h | --help)  _gclone_help; return 0 ;;
      *)
        print -u2 "gclone: unknown option: $1 (try: gclone --help)"
        return 1
        ;;
    esac
  done

  if (( $# == 0 )); then
    _gclone_help
    return 1
  fi

  local name=$1 dest=${2:-}
  local url=${GCLONE_REPOS[$name]}

  if [[ -z $url ]]; then
    print -u2 "gclone: unknown repository nickname: $name"
    print -u2 'Run "gclone --list" for valid names.'
    return 1
  fi

  if [[ -z $dest ]]; then
    local repo_basename="${url:t}"
    repo_basename="${repo_basename%.git}"
    dest="$PWD/$repo_basename"
  fi

  local parent="${dest:h}"
  [[ -n $parent ]] && command mkdir -p "$parent"

  if [[ -e $dest ]]; then
    if (( fresh )); then
      command rm -rf -- "$dest"
    else
      print -u2 "gclone: destination already exists: $dest"
      print -u2 "Remove it, pick another path, or use: gclone --fresh $name [dest]"
      return 1
    fi
  fi

  print -r -- "==> git clone → $dest"
  command git clone -- "$url" "$dest"
}

_gclone_list() {
  emulate -L zsh
  if (( ${#${(k)GCLONE_REPOS}} == 0 )); then
    print 'No repositories configured (edit repos.zsh next to this plugin).'
    return 0
  fi
  local k
  for k in ${(ok)GCLONE_REPOS}; do
    printf '%-28s %s\n' "$k" "${GCLONE_REPOS[$k]}"
  done
}

_gclone_help() {
  print "Usage: gclone [--fresh|-f] <nickname> [<destination>]"
  print "       gclone --list"
  print "       gclone --help"
  print ""
  print 'URLs live in repos.zsh beside gclone.plugin.zsh.'
  print 'Default destination is <repo-dir> in the current working directory (same rule as git: last URL path segment, without .git).'
  print 'Pass an optional second argument to clone to a different path.'
  print "With --fresh, remove an existing destination before cloning."
}

_gclone() {
  local -a repos
  repos=(${(k)GCLONE_REPOS})
  local curcontext="$curcontext" state line
  _arguments \
    '(-f --fresh)'{-f,--fresh}'[Remove destination if it exists before cloning]' \
    '(-l --list)'{-l,--list}'[List configured repository nicknames]' \
    '(-h --help)'{-h,--help}'[Show usage]' \
    '1: :->nick' \
    '2:clone directory:_path_files -/'
  case $state in
    nick)
      _describe -t repos 'repository' repos
      ;;
  esac
}

compdef _gclone gclone
