# shellcheck shell=bash
alias c=clear
alias cp='cp -vi'
alias mv='mv -vi'
alias mkdir='mkdir -v'
alias rm='rm -vi'
alias fdf='fd --max-results 1'
alias chmox='chmod +x'
alias pn='pnpm'
alias px='pnpx'
alias sv='pnpx sv'
alias e='exa -F'
alias r='cargo run --quiet --'
alias autin='atuin'
# alias pre-commit='prek'
alias opus='claude --model opus'
alias fable='claude --model fable'

# This tripped up AI way too often, I'm sick of it
# alias cat='cat -v'

alias j='jobs'
alias k="kill %1 && printf '\033[H\033[J'"
alias k1="kill %1 && printf '\033[H\033[J'"
alias k2="kill %2 && printf '\033[H\033[J'"
alias k3="kill %3 && printf '\033[H\033[J'"
alias zq="zoxide query"
alias tachyon="py -m profiling.sampling"

alias pa='pi --no-skills --skill ~/skills/work --provider anthropic --model sonnet-4-6 --thinking high'
alias po='pi --no-skills --skill ~/skills/public --provider openai-codex --model gpt-5.5 --thinking high'

function feedparse() {
  uvx --with feedparser python -c 'import readline, sys, feedparser; print(feedparser.parse(sys.stdin.read())' | yq -P
}

function cd() {
  if [ "$#" -gt 1 ] || [[ "$*" =~ "--help" ]]; then
    # cd ... ... [...]+` and `cd --help` is unchanged
    command cd "$@"
  elif [ "$1" = "-" ]; then
    # `cd -` becomes `popd`
    popd
  else
    if [ "$#" -eq 0 ]; then
        pushd ~
        return
    fi
    # `cd X` becomes `pushd [X or find X in zoxide]`  
    local match="$(zoxide query "$1" 2>/dev/null)"
    [ "$PWD" -ef "$match" ] && match=""
    [ -z "$match" ] && {
      [ "$PWD" -ef "$1" ] && return
    }
    if [ -z "$match" ]; then
      pushd "$1"
    else
      pushd "$1" 2>/dev/null || pushd "$match"
    fi
  fi
}

function sudo() {
  if [ "$#" -eq 0 ] || [[ "$*" =~ "--help" ]]; then
    command sudo "$@"
  else
    command sudo -E env "PATH=$PATH" "$@"
  fi
}

function z() {
  local match="$(zoxide query "$1")"
  [ -n "$match" ] && pushd "$match"
}

function path-add() {
  [ -z "$1" ] && return
  [ -d "$1" ] || return

  NEWPATH="$1"
  case ":${PATH}:" in
  "$NEWPATH":* | *:"$NEWPATH"* | *:"$NEWPATH":*) ;;
  *) export PATH="$PATH:$NEWPATH" ;;
  esac
}

function fork-sync() {
  local branch="${1:-main}"
  git pull --rebase upstream "$branch" && git push origin "$branch"
}

function shell-restart() {
  exec "/opt/homebrew/bin/bash" -l
}

function where() {
  which -a "$1" | uniq
}

function wt() {
  pushd ".wt/$1" 2>/dev/null || {
    # shellcheck disable=SC2164
    git wt add "$1" && pushd ".wt/$1"
  }
}

function fuck-off() {
  find "$1" -type f \( -perm -111 -o -name "*.dylib" \) -print0   | xargs -0 -n 1 -P 4 codesign --force --sign -
  codesign --force --deep --sign - "$1"
}

if which wine 1>/dev/null 2>&1; then
  export C=~/.wine/drive_c
  jazz() {
    wine "$C/Games/Jazz2/Jazz2.exe" "$@"
  }
fi
