#!/bin/bash
# GET THE RIGHT COMMAND: ./manage.tool
# shellcheck source=/dev/null
source variables.sh
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
