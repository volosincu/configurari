#!/bin/bash 

#./parse.sh -f /home/sony/script/colorez/i3 --indicator='#cdcdcd' --urgent-bg='red' --urgent-border='blue' --urgent-text='green'

if [[ $# -gt 0 ]] ; then
   
  set -- `getopt -o f: --long indicator::,urgent-bg::,urgent-border::,urgent-text:: -n 'entering in parse.sh' -- "$@"`
  

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
           lngth=split(args,axargs ," ");
            
           for (i=1;i<=lngth;i++){
             rgx="^(set)[[:blank:]]+\\$" axopts[i]
             if(match($0, rgx)){
               where=match($0, "(#[a-zA-Z0-9]{6})"); 
               if(where){ 
                  st = substr($0, RSTART, RLENGTH) ; 
                  gsub(st , axargs[i], $0);
               }

             }
           }
           print $0
         } # endbody
         END { }' $cfgfile > $onfile
  fi
else
  echo "Please supply at least an parameter!"
fi

