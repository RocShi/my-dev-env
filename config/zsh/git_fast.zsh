zmodload zsh/complist

_git_branches_only() {
    local -a branches
    branches=(${$(git for-each-ref --format='%(refname:short)' refs/heads/)})
    compadd -V branches -a branches
}


zle -C _git_branches_only_widget menu-select _git_branches_only

zstyle ':completion:*:*:git-checkout:*' command 'git for-each-ref --format="%(refname:short)" refs/heads/'
zstyle ':completion:*:*:git-checkout:*' insert-ids single
zstyle ':completion:*:*:git-checkout:*' sort false

_git_fast_hybrid() {
    local cmd="${words[2]}"
    local cur_index=$CURRENT
    local cur_word="${words[cur_index]}"

    case "$cmd" in
        co|checkout|switch|merge|rebase|branch|log|reset) ;;
        *) (( $+functions[_git] )) || autoload -Uz _git; _git "$@"; return ;;
    esac

    if [[ $cur_index -le 2 ]]; then
         (( $+functions[_git] )) || autoload -Uz _git; _git "$@"; return
    fi

    if [[ "$cur_word" =~ ^- ]]; then
        local help_text
        help_text=$(git "$cmd" -h 2>&1)
        
        local -a flags
        flags=($(echo "$help_text" | grep -o -- '-[a-zA-Z0-9-]\+' | sort -u))

        if (( ${#flags[@]} )); then
             if [[ ${#flags[@]} -ne ${#${flags:#${cur_word}*}} ]]; then
                 _describe 'command' flags
                 return 0
             fi
        fi
    fi

    if [[ ! "$cur_word" =~ ^- ]]; then
        local -a branches
        branches=(${$(git for-each-ref --format='%(refname:short)' refs/heads/ 2>/dev/null)})
        if (( ${#branches[@]} )); then
            compadd -V branches -a branches
            return 0
        fi
    fi

    (( $+functions[_git] )) || autoload -Uz _git
    _git "$@"
}

compdef -d git
compdef _git_fast_hybrid git

zstyle ':fzf-tab:complete:git-(checkout|co|switch|merge|rebase|branch|log|reset):*' fzf-flags --preview-window=hidden
