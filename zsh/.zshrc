# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  #source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# Load modules
autoload -U compinit; compinit
autoload -U colors && colors
    # _comp_options+=(globdots) # With hidden files
    # source $ZDOTDIR/completion.zsh
# autoload -U tetris # main attraction of zsh

# cmp opts
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

# prompt with git branch name - credit: https://gist.github.com/jftuga/f3cd06f5f9f4ed5ec952e2ec8f42e07d
## I'll try to implement this with the prompt below
function parse_git_branch() {
    if git branch &>/dev/null; then
        #git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1/p'
        git_branch="$(git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1/p')"
        #git_status="$(git status -s 2>/dev/null | wc -l)"
        echo "$git_branch]" #$status]"
    fi
}

COLOR_DEF_END=$'%f'
COLOR_WHITE=$'%F{#cdd6f4}'
COLOR_MAUVE=$'%F{#7287fd}'
COLOR_PINK=$'%F{#f5c2e7}'
COLOR_BLACK=$'%F{#1e1e2e}'
setopt PROMPT_SUBST
PROMPT_CWD='${COLOR_MAUVE}%~ ${COLOR_PINK}$(parse_git_branch) ${COLOR_DEF_END}'
export NEWLINE=$'\n'
# prompt 1:
    export PROMPT="${NEWLINE}${PROMPT_CWD}${NEWLINE}${COLOR_WHITE}%n@%m${COLOR_DEF_END}${COLOR_PINK}${COLOR_DEF_END}${COLOR_MAUVE} $ ${COLOR_DEF_END}"
    RPROMPT="${COLOR_PINK}%D{%H:%M:%S}%f"
# prompt 2:
    # export PROMPT="${NEWLINE}${PROMPT_CWD}${NEWLINE}${COLOR_WHITE}%n@%m ${COLOR_DEF_END} ${COLOR_PINK}%D{%H:%M:%S} ${COLOR_DEF_END} $ "

# set up prompt - credits to Bread on Penguins -> https://github.com/BreadOnPenguins/dots/blob/master/.config/zsh/.zshrc
    #NEWLINE=$'\n'
    #PROMPT="${NEWLINE}%K{#1e1e2e}%F{#cdd6f4} $0 %K{#313244}%F{#cdd6f4} %n %K{#45475a} %~ %f%k %F{#b4befe}❯%f " # catppuccino mocha based theme
    #PROMPT="${NEWLINE}%K{#2E3440}%F{#E5E9F0}$(date +%_I:%M%P) %K{#3b4252}%F{#ECEFF4} %n %K{#4c566a} %~ %f%k ❯ " # nord theme
    #PROMPT="${NEWLINE}%K{#32302f}%F{#d5c4a1} $0 %K{#3c3836}%F{#d5c4a1} %n %K{#504945} %~ %f%k ❯ " # warmer theme
    # PROMPT="${NEWLINE}%K{$COL0}%F{$COL1}$(date +%_I:%M%P) %K{$COL0}%F{$COL2} %n %K{$COL3} %~ %f%k ❯ " # pywal colors, from postrun script

# echo -e "${NEWLINE}\033[48;2;46;52;64;38;2;216;222;233m $0 \033[0m\033[48;2;59;66;82;38;2;216;222;233m $(uptime -p | cut -c 4-) \033[0m\033[48;2;76;86;106;38;2;216;222;233m $(uname -r) \033[0m" # nord theme
# echo -e "${NEWLINE}\x1b[38;5;137m\x1b[48;5;0m it's$(date +%_I:%M%P) \x1b[38;5;180m\x1b[48;5;0m $(uptime -p | cut -c 4-) \x1b[38;5;223m\x1b[48;5;0m $(uname -r) \033[0m" # warmer theme
#echo -e "${NEWLINE}\x1b[38;5;137m\x1b[48;5;0m it's$(print -P '%D{%_I:%M%P}\n') \x1b[38;5;180m\x1b[48;5;0m $(uptime -p | cut -c 4-) \x1b[38;5;223m\x1b[48;5;0m $(uname -r) \033[0m" # current


# Source aliases
source $ZDOTDIR/aliases




#cursor mode
#source "$ZDOTDIR/plugins/cursor_mode"

# Directory Stack (history of visited directories)
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

# options
## run 'set -o' to view a list out all zsh options (and which are currently enabled/disabled)
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt autocd # type a dir to cd
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
#set -o vi # set vi mode

# binds - see https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets for all possible keybind functions (widgets)
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
#bindkey "^k" kill-line
bindkey "^H" backward-word
bindkey "^L" forward-word
bindkey ";5;44~" clear-screen # ctrl ,
bindkey "^[[1;5D" backward-word # ctrl-left arrow
bindkey "^[[1;5C" forward-word # ctrl-right arrow
#bindkey "^H" backward-kill-word
# ctrl J & K for going up and down in prev commands
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward
#bindkey '^R' fzf-history-widget


# keep scrollback if terminal is foot - see https://codeberg.org/dnkl/foot/issues/933
if [[ $TERM =~ "^foot" ]]; then
	clear-screen-keep-sb() {repeat $((LINES-1)); do echo; done; zle .clear-screen}
	zle -N clear-screen clear-screen-keep-sb
fi

# yazi shell wrapper - auto cd to directory when exiting yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# source plugins
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-you-should-use/you-should-use.plugin.zsh
#source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme

## Powerlevel10k theme: To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
#[[ ! -f $ZDOTDIR/plugins/.p10k.zsh ]] || source /$ZDOTDIR/plugins/.p10k.zsh
