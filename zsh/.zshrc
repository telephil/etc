# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
# End of lines configured by zsh-newuser-install

alias ls='ls --color'

alias ll='ls -lF'
alias l='ls -alF'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

export PLAN9=/usr/local/plan9

export PATH=$PATH:$(brew --prefix)/bin:$HOME/bin:$HOME/bin/acme:$PLAN9/bin
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

THEME_FILE="$HOME/.config/colors/base16-shell/base16-ocean.dark.sh"
[[ -s $THEME_FILE ]] && source $THEME_FILE

# Completion
autoload -U compinit
compinit
setopt completealiases

# GIT
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '[%b] '

autoload -U colors && colors
PROMPT="%~ \$vcs_info_msg_0_%% "
