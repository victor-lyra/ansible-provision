
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=15000
SAVEHIST=15000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/victor/.zshrc'

autoload -Uz compinit
compinit

# referencia: man zshcompsys / man zshoptions
setopt MENU_COMPLETE
zstyle ':completion:*' completer _expand_alias _complete _correct _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Colors for files and directory
eval "$(dircolors -b)"
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
# End of lines added by compinstall

# Plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-sudo/sudo.plugin.zsh
#

# history (man zshoptions, zshparam)
zshaddhistory() { 
  emulate -L zsh
  whence ${${(z)1}[1]} >| /dev/null || return 1 
  [[ $1 != ${~HISTORY_IGNORE} ]]
} # https://superuser.com/a/902508
export HISTORY_IGNORE="(l|l.|la|ld|ls|ll|pwd|exit|history|man *|which *|cht *)"
setopt HIST_FIND_NO_DUPS # na busca do historico, nao exibe duplicatas
setopt HIST_IGNORE_DUPS # ignora se comandos duplicados na sequencia
setopt HIST_IGNORE_SPACE # comandos iniciados com espaço nao entram no historico
setopt INC_APPEND_HISTORY # escreve no historico imediatamente apos expansao do comando
#

# random prompt
declare -a PROMPTS
PROMPTS=(
    "∮"
    "∯"
    "ɬ"
    #"ʝʆϟ"
    "⍭"
    "≣"
    "⩾"
    "ǂ"
    "ᶑ"
    "⟫"
    "ϟ"
)

export MY_PROMPT_SYMBOL=${PROMPTS[($((`date +%d` % 10)))+1]}
sed -i 's/\[.\]/\['"$MY_PROMPT_SYMBOL"'\]/g' ~/.config/starship.toml
#

# load starship
eval "$(starship init zsh)"
#

# correcao de mapeamento da tecla
bindkey  "^[[3~"  delete-char                   # DEL
bindkey  "^[[1;5D"  backward-word               # CTRL+Left
bindkey  "^[[1;5C"  forward-word                # CTRL+Right
bindkey  "^[[H"  beginning-of-line              # Home
bindkey  "^[[F"  end-of-line                    # End
bindkey  "^[[5~"  history-search-backward       # PgUp
bindkey  "^[[6~"  history-search-forward        # PdDown
bindkey  "^[[5;2~"  halfpage-up                 # Shift+PgUp
bindkey  "^[[6;2~"  halfpage-down               # Shift+PgDown
bindkey  "^[[2~"  overwrite-mode                # Ins

## Editor padrao
export EDITOR=nvim

## nvim como MANPAGER
export MANPAGER='nvim +Man!'
#export MANWIDTH=999

## 'bat' como MANPAGER
#if [ -x "$(command -v bat)" ] 
#then
#  export MANROFFOPT="-c" # correction to "man" that uses ANSI escape sequences
#  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#fi

# fzf, fd, bat combo
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -x /usr/bin/fd ] 
  then
    export FZF_DEFAULT_OPTS="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (less -f {}) 2> /dev/null | head -300' \
--preview-window='right:hidden:wrap' \
--height 50% --border -1 --reverse --multi --info inline
--header 'F10: Preview / F11: copy' \
--bind 'f10:toggle-preview,f11:execute-silent(echo -n {+} | xclip -selection clipboard)'" 
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude .git --exclude fedfiles'
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
    export FZF_ALT_C_COMMAND="fd --type d --follow --hidden --exclude .git --exclude fedfiles"
fi

## Aliases
[[ -f ~/.aliases ]] && . ~/.aliases

## keychain (https://wiki.archlinux.org/title/SSH_keys#Keychain)
eval $(keychain --eval --quiet --nogui ~/.ssh/id_ed25519)