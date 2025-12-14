alias c=clear
alias cp='cp -vi'
alias mv='mv -vi'
alias rm='rm -vi'
alias fdf='fd --max-results 1'

alias pn='pnpm'
alias px='pnpx'
alias sv='pnpx sv'
alias poetry='uvx poetry'
alias e='exa -F'
alias r='cargo run --quiet --'
alias autin='atuin'
alias pre-commit='prek'

function path-add() {
    [ -z "$1" ] && return

    NEWPATH="$1"
    case ":${PATH}:" in
        "$NEWPATH":* | *:"$NEWPATH"* | *:"$NEWPATH":* ) ;;
        *) export PATH="$PATH:$NEWPATH" ;;
    esac
}

function fork-sync() {
    git pull upstream main && git push origin main
}

function where() {
    which -a $1 | uniq
}

if which wine 1> /dev/null 2>&1; then
    export C=~/.wine/drive_c
    jazz() {
        wine $C/Games/Jazz2/Jazz2.exe $@
    }
fi

[[ -f ~/.private_aliases ]] && . ~/.private_aliases
