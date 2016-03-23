if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi
if [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
	source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
fi

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

export PS1="\w \$(__git_ps1 \"(%s) \")% "

THEME_FILE="$HOME/.config/colors/base16-shell/base16-default.dark.sh"
[[ -s $THEME_FILE ]] && source $THEME_FILE

