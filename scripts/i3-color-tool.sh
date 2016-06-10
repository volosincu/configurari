#!/bin/bash 


#  ./i3-color-tool.sh \
#   -f /home/sony/.config/i3/config \
#   --indicator='#FF0040' \
#   --urgent-bg='#E53935' \
#   --urgent-border='#E53935' \
#   --urgent-text='#f3f4f5' \
#   --wn-focused-border='#49626d' \
#   --wn-focused-bg='#49626d' \
#   --wn-focused-text='#ffffff' \
#   --wn-inactive-border='#35393c' \
#   --wn-inactive-bg='#35393c' \
#   --wn-inactive-text='#c0c2c8' \
#   --bar-bg='#2f343f' \
#   --bar-separator='#757575' \
#   --bar-focus-ws-border='#c37654' \
#   --bar-focus-ws-bg='#c37654' \
#   --bar-focus-ws-text='#ffffff' \
#   --bar-inactive-ws-border='#373b41' \
#   --bar-inactive-ws-bg='#373b41' \
#   --bar-inactive-ws-text='#7d7f7d'


if [[ $# == 0 ]] ; then
  echo "Please supply at least an parameter!"
  exit
fi


set -- `getopt -o f: --long \
indicator:,\
urgent-bg:,\
urgent-border:,\
urgent-text:,\
wn-focused-border:,\
wn-focused-bg:,\
wn-focused-text:,\
wn-inactive-border:,\
wn-inactive-bg:,\
wn-inactive-text:,\
bar-bg:,\
bar-separator:,\
bar-focus-ws-border:,\
bar-focus-ws-bg:,\
bar-focus-ws-text:,\
bar-inactive-ws-border:,\
bar-inactive-ws-bg:,\
bar-inactive-ws-text: -n 'entering in parse.sh' -- "$@"`
  

  params=`echo $@ | awk 'BEGIN {}{gsub(/--[^[:alnum:]]/, "==");  print $0 }'`
  valid_opt=`echo $params | awk 'BEGIN {FS="==";}{print NF }'`
  
  if [[ $valid_opt -gt 1 ]];then
    invalid_params=`echo $params | awk 'BEGIN {FS="==";}{print $2 }'`
    echo -e "\nPlease provide the parameters" $invalid_params  " in the: \n\t 1) short form: -a, -a=\"value\" or \n\t 2) long form : --param-name, --param-name=\"value\""
  else

    filex=2
    for i in $@; do
      if [ $i == "-f" -o $i == "--file" ]; then
        cfgfile=${!filex}
        cfgfile=${cfgfile:1:${#cfgfile}-2}
      fi
      ((filex++))
    done
    
    declare -a optsx argsx
    
    # TODO - change code to iterate throught arguments without deleting them
    # add options and their arguments in separate arrays 
    j=0
    while [ $# -gt 1 ];do
      key=`echo $1 | sed -r 's/^(--|-)//'`
      val=$2
      shift 2
      [ $key == "f" -o $key == "file" ] && continue
      optsx[$j]=$key
      argsx[$j]=${val:1:${#val}-2}
      ((j++))
    done



    onfile=./i3-$(date +%s).file
    awk -v opts="${optsx[*]}" -v args="${argsx[*]}" '

         {
           split(opts,axopts ," ");
           lngth = split(args,axargs ," ");
            
           for (i=1;i<=lngth;i++){
             rgx = "^(set)[[:blank:]]+\\$" axopts[i]
             if(match($0, rgx)){
               where = match($0, "(#[a-zA-Z0-9]{6})"); 
               if(where){ 
                  st = substr($0, RSTART, RLENGTH) ; 
                  gsub(st , axargs[i], $0);
               }

             }
           }
           print $0
         } 
         END { }' $cfgfile > $onfile
  fi

