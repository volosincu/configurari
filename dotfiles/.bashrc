#!/bin/bash






# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\033[01;32m\]\u@\h\033[00m\]:\[\033[01;31m\]\W\[\033[00m\]]\$ '
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

alias lls="ls -la --color=auto"

alias usba="cd /mnt/usb/usba"
alias usbb="cd /mnt/usb/usbb"

alias mnta="sudo mount -t vfat /dev/sdb1 /mnt/usb/usba"
alias umnta="sudo umount /dev/sdb1"

alias mntb="sudo mount -t vfat /dev/sdc1 /mnt/usb/usbb"
alias umntb="sudo umount /dev/sdc1"



