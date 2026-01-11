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
alias cd='pushd'
alias k='kill %1'
alias k1='kill %1'
alias k2='kill %2'
alias k3='kill %3'

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
