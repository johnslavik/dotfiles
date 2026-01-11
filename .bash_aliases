# shellcheck shell=bash
alias c=clear
alias cp='cp -vi'
alias mv='mv -vi'
alias rm='rm -vi'
alias fdf='fd --max-results 1'
alias chmox='chmod +x'
alias pn='pnpm'
alias px='pnpx'
alias sv='pnpx sv'
alias poetry='uvx poetry'
alias e='exa -F'
alias r='cargo run --quiet --'
alias autin='atuin'
alias pre-commit='prek'
alias cat='cat -v'
alias j='jobs'
alias k="kill %1 && printf '\033[H\033[J'"
alias k1="kill %1 && printf '\033[H\033[J'"
alias k2="kill %2 && printf '\033[H\033[J'"
alias k3="kill %3 && printf '\033[H\033[J'"

function cd() {
  if [ "$#" -eq 0 ] || [ "$#" -gt 1 ] || [[ "$*" =~ "--help" ]]; then
    # `cd`, `cd ... ... [...]+` and `cd --help` is unchanged
    command cd "$@"
  elif [ "$1" = "-" ]; then
    # `cd -` becomes `popd`
    popd
  else
    # `cd X` becomes `pushd [X or find X in zoxide]`  
    local match="$(zoxide query "$1" 2>/dev/null)"
    [ "$PWD" -ef "$match" ] && match=""
    [ -z "$match" ] && {
      [ ! -d "$1" ] && return
      [ "$PWD" -ef "$1" ] && return
    }
    if [ -z "$match" ]; then
      pushd "$1"
    else
      pushd "$1" 2>/dev/null || pushd "$match"
    fi
  fi
}

function z() {
  local match="$(zoxide query "$1")"
  [ -n "$match" ] && pushd "$match"
}

function path-add() {
  [ -z "$1" ] && return

  NEWPATH="$1"
  case ":${PATH}:" in
  "$NEWPATH":* | *:"$NEWPATH"* | *:"$NEWPATH":*) ;;
  *) export PATH="$PATH:$NEWPATH" ;;
  esac
}

function fork-sync() {
  local branch="${1:-main}"
  git pull upstream "$branch" && git push origin "$branch"
}

function where() {
  which -a "$1" | uniq
}

if which wine 1>/dev/null 2>&1; then
  export C=~/.wine/drive_c
  jazz() {
    wine "$C/Games/Jazz2/Jazz2.exe" "$@"
  }
fi
