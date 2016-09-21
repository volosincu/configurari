# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi



PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;31m\] \W\[\033[00m\]] \$'
PS2='> '
PS3='> '
PS4='+ '

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion




[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion


toField (){
	awk -v col="$1" '{print substr($0, 0, index($0,col)-1)}'
}

fromField (){
	awk -v col="$1" '{print substr($0, index($0,col))}'
}

print_line () {
        red='\e[0;36m'
	gray='\e[2;49;37m'
        endColor='\e[0m'
	
        first=${1%% *}
        rest=${1#* }
	
	cols=`echo $rest | awk '{print NF}'`
	let cols=$cols-0
	after8col=""

	if [ $cols -gt 8 ] 
	then 
		the9col=`echo $rest | awk '{print $9}'`
		after8col=`echo $rest | fromField $the9col`
	fi

	the8col=`echo $rest | awk '{print $8}'`
	first7cols=`echo $rest | toField $the8col`
	
	isHidden=`echo | awk -v clm="$the8col" '{print clm ~ /^\./}'`
	col8Color=$red
	
	if [ $isHidden == "1" ] 
	then 
		col8Color=$gray 
	fi

        echo -e "${red}$first${endColor} $first7cols ${col8Color} $the8col ${endColor} ${gray}$after8col ${endColor}"
}

ll () {
        #echo $1
        IFS=$'\n'; while read line;
        do
        #       echo "$line"
                print_line $line
        #done <<< "$(find $1 -maxdepth 1 -printf '%M %p\n')"
        done <<< "$(ls -la $1 )"
}


alias vi="vim"
alias em="emacs -nw --file"
alias ..="cd .."
alias ...="cd ../cd .."

alias lls="ls -la --color=auto"
alias la="ll"

xrdb -load ~/.Xresources



export PATH="$PATH:$HOME/bin"
export JAVA_HOME="/usr/bin/java/jdk1.8.0_102"
export PATH="$PATH:$JAVA_HOME/bin"
export M2_HOME="/usr/local/bin/apache-maven"
export PATH="$PATH:$M2_HOME/bin"
export GRADLE_HOME="/usr/local/bin/gradle"
export PATH="$PATH:$GRADLE_HOME/bin"


