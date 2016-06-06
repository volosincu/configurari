#!/bin/bash 


#./parse.sh -btest --testt='spec' --unu un --alt nae




#./parse.sh -b test --testt='spec' --unu un --alt='nae' --file='/home/sony/script/colorez/i3'

#TEMP=`getopt -o -n 'parse.sh' -- "$@"`
#eval set -- "$TEMP"

#echo $@
if [[ $# -gt 0 ]] ; then
   
  set -- `getopt -o f: --long indicator::,urgent-bg::,urgent-border::,urgent-text:: -n 'entering in parse.sh' -- "$@"`
  

  params=`echo $@ | awk 'BEGIN {}{gsub(/--[^[:alnum:]]/, "==");  print $0 }'`
  valid_opt=`echo $params | awk 'BEGIN {FS="==";}{print NF }'`
  
  if [[ $valid_opt -gt 1 ]];then
    invalid_params=`echo $params | awk 'BEGIN {FS="==";}{print $2 }'`
    echo -e "\nPlease provide the parameters" $invalid_params  " in the: \n\t 1) short form: -a, -a=\"value\" or \n\t 2) long form : --param-name, --param-name=\"value\""
  else
    i=0 
    while [ $# -gt 1 ];do
      key=$1
      val=$2
      if [ $key == "-f" -o $key == "--file" ]; then
        echo "reading config file : "$val
        onfile=./i3-$(date +%s).file  
	awk '{print $0}'  ${val:1:${#val}-2} > $onfile
      fi 
      
      shift 2;
      echo $key $val | awk '{print $1, $2}'
    done
  fi
else
  echo "Please supply at least an parameter!"
fi


#echo "&&& "$@" &&&"

