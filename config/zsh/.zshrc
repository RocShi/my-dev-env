# --- 1. Environment & History ---
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.

# --- 2. Options ---
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # The pushd command will not push duplicates onto the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt CORRECT              # Spelling correction
setopt INTERACTIVE_COMMENTS # Allow comments even in interactive shell (especially for Zsh)

# --- 3. Colors ---
autoload -Uz colors && colors
# Enable ls colors
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
if ls --color > /dev/null 2>&1; then # GNU ls
    alias ls='ls --color=auto'
elif ls -G > /dev/null 2>&1; then # macOS/BSD ls
    alias ls='ls -G'
fi

# --- 4. Completion System ---
# Add zsh-completions to fpath BEFORE compinit
if [ -d "$HOME/.config/zsh/plugins/zsh-completions/src" ]; then
    fpath=($HOME/.config/zsh/plugins/zsh-completions/src $fpath)
fi

# Initialize completion system
autoload -Uz compinit
# -u: insecure (ignore permissions check), useful for containers/shared envs
# -C: check cache
compinit -u

# --- Improved Completion Experience (Fish-like) ---
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*' verbose true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcache"
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-fetch:*' fetch-all-branches false
zstyle ':completion:*:git-pull:*' fetch-all-branches false

# --- 5. Plugins ---
PLUGIN_DIR="$HOME/.config/zsh/plugins"

# fzf-tab
if [ -f "$PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh" ]; then
    source "$PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh"
fi

# zsh-autosuggestions
if [ -f "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    # Optional config: Grey color for suggestions
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
fi

# zsh-syntax-highlighting (Should be loaded last among plugins)
if [ -f "$PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --- 6. Prompt ---
_git_prompt_info() {
    # Suppress all errors to prevent prompt corruption
    (
        setopt localoptions
        setopt errreturn 2>/dev/null || true  # Ignore if errreturn not available
        
        # Check if we're in a git repository
        local git_dir=$(git rev-parse --git-dir 2>/dev/null)
        [[ -z "$git_dir" ]] && return 0
        
        # Try to get branch name - works in both regular repos and submodules
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        
        # If not on a branch (detached HEAD), show commit hash
        if [[ -z "$branch" ]]; then
            branch=$(git rev-parse --short HEAD 2>/dev/null)
            [[ -n "$branch" ]] && branch="$branch"
        fi
        
        # Output branch info if available
        [[ -n "$branch" ]] && echo "%F{#AE81FF}%B($branch)%b%f"
    ) 2>/dev/null || true
}
setopt PROMPT_SUBST
PROMPT='%F{#A6E22E}%B%n%b%f@%F{#E3E3DD}%B%m%b%f %F{#819AFF}%B%~%b%f $(_git_prompt_info)
%F{#A6E22E}%B❯%b%f '

# --- 7. Aliases ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Git aliases (Common ones)
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# --- 8. Keybindings ---
bindkey -e              # Emacs mode
# Fix arrow keys history search
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# Ctrl+Left / Ctrl+Right -> Move word by word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# --- 9. custom ---
source ~/.config/zsh/custom.zsh

# --- 10. fzf ---
source ~/.config/zsh/fzf.zsh

# --- 11. zoxide ---
source ~/.config/zsh/zoxide.zsh

# --- 12. git_fast ---
source ~/.config/zsh/git_fast.zsh
