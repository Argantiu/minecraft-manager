#!/bin/bash
# GET THE RIGHT COMMAND: ./manage.tool
MLANG=./mcsys/configs/messages.lang
CONYAM=./mcsys/configs/mcsys.yml
MTPATH=$(cat < $CONYAM | grep "server-directory:" | cut -d ':' -f2 | tr -d " ")
MPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
MCNAME=$(cat < $CONYAM | grep "systemname:" | cut -d ':' -f2)
MANAGET1=$(cat < $MLANG | grep "manage.tool.output:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
MANAGET2=$(cat < $MLANG | grep "manage.tool.remove:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
MANAGET3=$(cat < $MLANG | grep "manage.tool.remove.ok:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
MANAGET4=$(cat < $MLANG | grep "manage.tool.remove.no:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
MANAGET5=$(cat < $MLANG | grep "manage.tool.no.input:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
# Selector to have a nice overview about the commands.
echo -e "$MANAGET1"
echo -n ">>  ";
{
echo -n "";
read MUPSTAT;
}
case $MUPSTAT in
1)
  /bin/bash $MTPATH/mcsys/start.sh
  exit 0
;;
2)
  /bin/bash $MTPATH/mcsys/stop.sh
  exit 0
;;
3)
  /bin/bash $MTPATH/mcsys/restart.sh
  exit 0
;;
4)
  joe $MTPATH/mcsys/configs/mcsys.yml
  exit 0
;;
5)
  echo -e "$MANAGET2"
  echo -n ">> ";
  {
  echo -n "";
  read MCONFIRM;
  }
  if [[ $MCONFIRM == "Ja" ]] || [[ $MCONFIRM == "ja" ]] || [[ $MCONFIRM == "yes" ]] || [[ $MCONFIRM == "Yes" ]]; then /bin/bash $MTPATH/mcsys/stop.sh && sleep 10s && rm -r ./mcsys && echo -e "$MANAGET3"
   rm -- "$0"
   exit 0
  else echo -e "$MANAGET4"
   exit 0
  fi
;;
*)
  echo -e "$MANAGET5"
;;
esac
exit 1
